require 'reel'

module Berkshelf::API
  class RESTGateway < Reel::Server
    extend Forwardable
    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging

    DEFAULT_OPTIONS = {
      host: '0.0.0.0',
      port: 26200,
      quiet: false,
      workers: 10
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
      connection.each_request do |request|
        if request.websocket?
          request.respond(:bad_request, "WebSockets not supported")
        else
          route_request(request)
        end
      end
    end

    def route_request(request)
      options = {
        :method       => request.method,
        :input        => request.body.to_s,
        "REMOTE_ADDR" => request.remote_addr
      }.merge(convert_headers(request.headers))

      status, headers, body = app.call(::Rack::MockRequest.env_for(request.url, options))

      if body.respond_to?(:to_str)
        request.respond status_symbol(status), headers, body.to_str
      elsif body.respond_to?(:each)
        request.respond status_symbol(status), headers.merge(transfer_encoding: :chunked)
        body.each { |chunk| request << chunk }
        request.finish_response
      else
        log.error "don't know how to render: #{body.inspect}"
        request.respond :internal_server_error, "An error occurred processing your request"
      end

      body.close if body.respond_to?(:close)
    end

    def convert_headers(headers)
      Hash[headers.map { |key, value| ['HTTP_' + key.upcase.gsub('-','_'),value ] }]
    end

    def status_symbol(status)
      if status.is_a?(Fixnum)
        Http::Response::STATUS_CODES[status].downcase.gsub(/\s|-/, '_').to_sym
      else
        status.to_sym
      end
    end
  end
end
