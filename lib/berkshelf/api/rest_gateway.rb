require 'reel'

module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  class RESTGateway < Reel::Server
    extend Forwardable
    include Celluloid
    include Celluloid::Logger

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

    def_delegator :handler, :rack_app

    finalizer do
      pool.terminate if pool && pool.alive?
    end

    # @option options [String] :host ('0.0.0.0')
    # @option options [Integer] :port (26100)
    # @option options [Boolean] :quiet (false)
    # @option options [Integer] :workers (10)
    def initialize(options = {})
      options       = DEFAULT_OPTIONS.merge(options)
      options[:app] = Berkshelf::API::RackApp.new

      @host    = options[:host]
      @port    = options[:port]
      @workers = options[:workers]
      @handler = ::Rack::Handler::Reel.new(options)
      @pool    = ::Reel::RackWorker.pool(size: @workers, args: [ @handler ])

      debug "REST Gateway listening on #{@host}:#{@port}"
      super(@host, @port, &method(:on_connect))
    end

    # @param [Reel::Connection] connection
    def on_connect(connection)
      pool.handle(connection.detach)
    end

    private

      # @return [Reel::RackWorker]
      attr_reader :pool
      # @return [Rack::Handler::Reel]
      attr_reader :handler
  end
end
