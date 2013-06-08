trap 'INT' do
  Berkshelf::API::Application.shutdown
end

trap 'TERM' do
  Berkshelf::API::Application.shutdown
end

module Berkshelf::API
  class ApplicationSupervisor < Celluloid::SupervisionGroup
    def initialize(registry)
      super
      supervise_as(:cache_manager, Berkshelf::API::CacheManager)
      supervise_as(:cache_builder, Berkshelf::API::CacheBuilder)
      supervise_as(:rest_gateway, Berkshelf::API::RESTGateway)
    end
  end

  module Application
    class << self
      extend Forwardable
      include Berkshelf::API::Logging

      def_delegators :registry, :[], :[]=

      def instance
        return @instance unless @instance.nil?

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
      def run
        loop do
          supervisor = run!

          sleep 0.1 while supervisor.alive?

          break if @shutdown

          log.error "!!! #{self} crashed. Restarting..."
        end
      end

      def run!
        @instance = ApplicationSupervisor.new(registry)
        Berkshelf::API::CacheBuilder.start
        @instance
      end

      def shutdown
        @shutdown = true
        instance.terminate
      end
    end
  end
end
