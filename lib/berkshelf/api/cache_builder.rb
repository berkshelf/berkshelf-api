module Berkshelf::API
  class CacheBuilder
    require_relative 'cache_builder/worker'

    class WorkerSupervisor < Celluloid::SupervisionGroup; end

    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging

    server_name :cache_builder
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
