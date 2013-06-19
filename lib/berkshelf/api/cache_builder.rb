module Berkshelf::API
  class CacheBuilder
    require_relative 'cache_builder/worker'

    class WorkerSupervisor < Celluloid::SupervisionGroup; end

    class << self
      # @raise [Celluloid::DeadActorError] if Cache Builder has not been started
      #
      # @return [Celluloid::Actor(Berkshelf::API::CacheBuilder)]
      def instance
        unless Berkshelf::API::Application[:cache_builder] && Berkshelf::API::Application[:cache_builder].alive?
          raise NotStartedError, "cache builder not running"
        end
        Berkshelf::API::Application[:cache_builder]
      end

      # Start the cache builder and add it to the application's registry.
      #
      # @note you probably do not want to manually start the cache manager unless you
      #   are testing the application. Start the entire application with {Berkshelf::API::Application.run}
      def start
        instance.async(:build)
      end
    end

    include Celluloid
    include Berkshelf::API::Logging

    finalizer :finalize_callback

    def initialize
      log.info "Cache Builder starting..."
      @worker_registry   = Celluloid::Registry.new
      @worker_supervisor = WorkerSupervisor.new(@worker_registry)

      Application.config.endpoints.each do |endpoint|
        @worker_supervisor.supervise(CacheBuilder::Worker[endpoint.type], endpoint.options)
      end
    end

    def build
      @worker_supervisor.actors.map { |actor| actor.async(:build) }
    end

    private

      def finalize_callback
        log.info "Cache Builder shutting down..."
        @worker_supervisor.terminate if @worker_supervisor && @worker_supervisor.alive?
      end
  end
end
