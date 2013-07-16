trap 'INT' do
  Berkshelf::API::Application.shutdown
end

trap 'TERM' do
  Berkshelf::API::Application.shutdown
end

module Berkshelf::API
  class ApplicationSupervisor < Celluloid::SupervisionGroup
    # @option options [Boolean] :disable_http (false)
    #   run the application without the rest gateway
    def initialize(registry, options = {})
      super(registry)
      supervise_as(:cache_manager, Berkshelf::API::CacheManager)
      supervise_as(:cache_builder, Berkshelf::API::CacheBuilder)

      unless options[:disable_http]
        require_relative 'rest_gateway'
        supervise_as(:rest_gateway, Berkshelf::API::RESTGateway, options)
      end
    end
  end

  module Application
    class << self
      extend Forwardable
      include Berkshelf::API::Logging
      include Berkshelf::API::Mixin::Services

      def_delegators :registry, :[], :[]=

      def config
        @config ||= begin
          Berkshelf::API::Config.from_file(Berkshelf::API::Config.default_path)
        rescue
          Berkshelf::API::Config.new
        end
      end

      # @option options [String, Fixnum] :log_location (STDOUT)
      # @option options [String, nil] :log_level ("INFO")
      #   - "DEBUG
      #   - "INFO"
      #   - "WARN"
      #   - "ERROR"
      #   - "FATAL"
      def configure_logger(options = {})
        Logging.init(level: options[:log_level], location: options[:log_location])
      end

      # @return [String]
      def home_path
        ENV['BERKSHELF_API_PATH'] || config.home_path
      end

      # Retrieve the running instance of the Application
      #
      # @raise [Berkshelf::API::NotStartedError]
      #
      # @return [Berkshelf::API::Application]
      def instance
        return @instance if @instance

        raise NotStartedError, "application not running"
      end

      # The Actor registry for Berkshelf::API.
      #
      # @note Berkshelf::API uses it's own registry instead of Celluloid::Registry.root to
      #   avoid conflicts in the larger namespace. Use Berkshelf::API::Application[] to access Berkshelf::API
      #   actors instead of Celluloid::Actor[].
      #
      # @return [Celluloid::Registry]
      def registry
        @registry ||= Celluloid::Registry.new
      end

      # Run the application in the foreground (sleep on main thread)
      #
      # @option options [Boolean] :disable_http (false)
      #   run the application without the rest gateway
      def run(options = {})
        loop do
          supervisor = run!(options)

          sleep 0.1 while supervisor.alive?

          break if @shutdown

          log.error "!!! #{self} crashed. Restarting..."
        end
      end

      # Run the application in the background
      #
      # @option options [Boolean] :disable_http (false)
      #   run the application without the rest gateway
      # @option options [Boolean] :eager_build (false)
      #   automatically begin and loop all cache builders
      #
      # @return [Berkshelf::API::Application]
      def run!(options = {})
        options = { disable_http: false, eager_build: false }.merge(options)
        configure_logger(options)
        @instance = ApplicationSupervisor.new(registry, options)
        cache_builder.async(:build_loop) if options[:eager_build]
        @instance
      end

      # @return [Boolean]
      def running?
        instance.alive?
      rescue NotStartedError
        false
      end

      def shutdown
        @shutdown = true
        instance.terminate
      end
    end
  end
end
