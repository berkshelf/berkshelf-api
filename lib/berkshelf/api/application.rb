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

      attr_reader :start_time
      def_delegators :registry, :[], :[]=

      # @return [Berkshelf::API::Config]
      def config
        @config ||= begin
          Berkshelf::API::Config.from_file(Berkshelf::API::Config.default_path)
        rescue
          Berkshelf::API::Config.new
        end
      end

      # @param [Berkshelf::API::Config] config
      def set_config(config)
        @config = config
      end

      # Configure the application
      #
      # @option options [String] :config_file
      #   filepath to a configuration file to use
      # @option options [String, Fixnum] :log_location (STDOUT)
      # @option options [String, nil] :log_level ("INFO")
      #   - "DEBUG
      #   - "INFO"
      #   - "WARN"
      #   - "ERROR"
      #   - "FATAL"
      #
      # @raise [Berkshelf::API::ConfigNotFoundError]
      #
      # @return [Berkshelf::API::Config]
      def configure(options = {})
        unless options[:config_file].nil?
          set_config Berkshelf::API::Config.from_file(options[:config_file])
        end

        configure_logger(options)
        config
      rescue Buff::Errors::ConfigNotFound => ex
        raise ConfigNotFoundError, ex
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
        @start_time = Time.now.utc
        loop do
          supervisor = run!(options)

          while supervisor.alive?
            sleep 0.1
            instance.terminate if @shutdown
          end

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
        configure(options)
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

      # Shutdown the running instance
      #
      # @raise [Berkshelf::API::NotStartedError]
      #   if there is no running instance
      def shutdown
        @shutdown = true
      end
    end
  end
end
