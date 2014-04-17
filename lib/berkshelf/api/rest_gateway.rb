require 'reel'

module Berkshelf::API
  class RESTGateway < Reel::Server::HTTP
    extend Forwardable
    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging

    DEFAULT_OPTIONS = {
      host: '0.0.0.0',
      port: 26200,
      quiet: false,
      workers: 10
    }.freeze

    INITIAL_BODY = ''

    CONTENT_TYPE_ORIG   = 'Content-Type'.freeze
    CONTENT_LENGTH_ORIG = 'Content-Length'.freeze
    CONTENT_TYPE        = 'CONTENT_TYPE'.freeze
    CONTENT_LENGTH      = 'CONTENT_LENGTH'.freeze

    SERVER_SOFTWARE     = 'SERVER_SOFTWARE'.freeze
    SERVER_NAME         = 'SERVER_NAME'.freeze
    SERVER_PORT         = 'SERVER_PORT'.freeze
    SERVER_PROTOCOL     = 'SERVER_PROTOCOL'.freeze
    GATEWAY_INTERFACE   = "GATEWAY_INTERFACE".freeze
    LOCALHOST           = 'localhost'.freeze
    HTTP_VERSION        = 'HTTP_VERSION'.freeze
    CGI_1_1             = 'CGI/1.1'.freeze
    REMOTE_ADDR         = 'REMOTE_ADDR'.freeze
    CONNECTION          = 'HTTP_CONNECTION'.freeze
    SCRIPT_NAME         = 'SCRIPT_NAME'.freeze
    PATH_INFO           = 'PATH_INFO'.freeze
    REQUEST_METHOD      = 'REQUEST_METHOD'.freeze
    QUERY_STRING        = 'QUERY_STRING'.freeze
    HTTP_1_0            = 'HTTP/1.0'.freeze
    HTTP_1_1            = 'HTTP/1.1'.freeze
    HTTP_               = 'HTTP_'.freeze
    HOST                = 'Host'.freeze

    RACK_INPUT          = 'rack.input'.freeze
    RACK_LOGGER         = 'rack.logger'.freeze
    RACK_VERSION        = 'rack.version'.freeze
    RACK_ERRORS         = 'rack.errors'.freeze
    RACK_MULTITHREAD    = 'rack.multithread'.freeze
    RACK_MULTIPROCESS   = 'rack.multiprocess'.freeze
    RACK_RUN_ONCE       = 'rack.run_once'.freeze
    RACK_URL_SCHEME     = 'rack.url_scheme'.freeze
    RACK_WEBSOCKET      = 'rack.websocket'.freeze

    PROTO_RACK_ENV = {
      RACK_VERSION      => ::Rack::VERSION,
      RACK_ERRORS       => STDERR,
      RACK_MULTITHREAD  => true,
      RACK_MULTIPROCESS => false,
      RACK_RUN_ONCE     => false,
      RACK_URL_SCHEME   => "http".freeze,
      SCRIPT_NAME       => ENV[SCRIPT_NAME] || "",
      SERVER_PROTOCOL   => HTTP_1_1,
      SERVER_SOFTWARE   => "berkshelf-api/#{Berkshelf::API::VERSION}".freeze,
      GATEWAY_INTERFACE => CGI_1_1
    }.freeze

    # @return [String]
    attr_reader :host

    # @return [Integer]
    attr_reader :port

    # @return [Integer]
    attr_reader :workers

    # @return [Berkshelf::API::RackApp]
    attr_reader :app

    server_name :rest_gateway

    # @option options [String] :host ('0.0.0.0')
    # @option options [Integer] :port (26200)
    # @option options [Boolean] :quiet (false)
    # @option options [Integer] :workers (10)
    def initialize(options = {})
      options = DEFAULT_OPTIONS.merge(options)
      @host   = options[:host]
      @port   = options[:port]

      log.info "REST Gateway listening on #{@host}:#{@port}"
      super(@host, @port, &method(:on_connect))
      @app = Berkshelf::API::RackApp.new
    end

    def on_connect(connection)
      while request = connection.request
        case request
        when request.websocket?
          request.respond(:bad_request, "WebSockets not supported")
        else
          route_request(connection, request)
        end
      end
    end

    def route_request(connection, request)
      status, headers, body_parts = app.call(request_env(request, connection))
      body, is_stream             = response_body(body_parts)

      response_klass = is_stream ? Reel::StreamResponse : Reel::Response
      response       = response_klass.new(status, headers, body)
      connection.respond(response)
    end

    def request_env(request, connection)
      env = env(request)
      env[REMOTE_ADDR] = connection.remote_ip
      env
    end

    private

      def env(request)
        env = Hash[PROTO_RACK_ENV]

        env[RACK_INPUT] = StringIO.new(request.body.to_s || INITIAL_BODY)
        env[RACK_INPUT].set_encoding(Encoding::BINARY) if env[RACK_INPUT].respond_to?(:set_encoding)
        env[SERVER_NAME], env[SERVER_PORT] = (request[HOST]||'').split(':', 2)
        env[SERVER_PORT] ||= port.to_s
        env[HTTP_VERSION]   = request.version || env[SERVER_PROTOCOL]
        env[REQUEST_METHOD] = request.method
        env[PATH_INFO]      = request.path
        env[QUERY_STRING]   = request.query_string || ''

        (_ = request.headers.delete CONTENT_TYPE_ORIG) && (env[CONTENT_TYPE] = _)
        (_ = request.headers.delete CONTENT_LENGTH_ORIG) && (env[CONTENT_LENGTH] = _)

        request.headers.each_pair do |key, val|
          env[HTTP_ + key.gsub('-', '_').upcase] = val
        end
        env
      end

      def response_body(body_parts)
        if body_parts.respond_to?(:to_path)
          ::File.new(body_parts.to_path)
        else
          body = ''
          body_parts.each do |c|
            return [c, true] if c.is_a?(Reel::Stream)
            body << c
          end
          body_parts.close if body_parts.respond_to?(:close)
          body
        end
      end
  end
end
