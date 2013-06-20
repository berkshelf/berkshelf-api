require 'optparse'

trap 'INT' do
  Berkshelf::API::Application.shutdown
end

trap 'TERM' do
  Berkshelf::API::Application.shutdown
end

module Berkshelf::API
  class ApplicationSupervisor < Celluloid::SupervisionGroup
    def initialize(registry, options = {})
      super(registry)
      supervise_as(:cache_manager, Berkshelf::API::CacheManager)
      supervise_as(:cache_builder, Berkshelf::API::CacheBuilder)
      supervise_as(:rest_gateway, Berkshelf::API::RESTGateway, options)
    end
  end

  module Application
    class << self
      extend Forwardable
      include Berkshelf::API::Logging

      def_delegators :registry, :[], :[]=

      def config
        @config ||= begin
          Berkshelf::API::Config.from_file(Berkshelf::API::Config.default_path)
        rescue
          Berkshelf::API::Config.new
        end
      end

      def configure_logger(options = {})
        Logging.init(level: options[:log_level], location: options[:log_location])
      end

      def instance
        return @instance if @instance

        raise Celluloid::DeadActorError, "application not running"
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
      def run(options = {})
        loop do
          supervisor = run!(options)

          sleep 0.1 while supervisor.alive?

          break if @shutdown

          log.error "!!! #{self} crashed. Restarting..."
        end
      end

      def run!(options = {})
        configure_logger(options)
        @instance = ApplicationSupervisor.new(registry, options)
      end

      def shutdown
        @shutdown = true
        instance.terminate
      end
    end
  end
end
