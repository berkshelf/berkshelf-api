module Berkshelf::API
  class CacheBuilder
    require_relative 'cache_builder/worker'

    class WorkerSupervisor < Celluloid::SupervisionGroup; end

    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging
    include Berkshelf::API::Mixin::Services

    server_name :cache_builder
    finalizer :finalize_callback

    def initialize
      log.info "Cache Builder starting..."
      @worker_registry   = Celluloid::Registry.new
      @worker_supervisor = WorkerSupervisor.new(@worker_registry)
      @building          = false
      @build_interval   = Application.config.build_interval

      Application.config.endpoints.each_with_index do |endpoint, index|
        endpoint_options = (endpoint.options || {}).to_hash.deep_symbolize_keys
        @worker_supervisor.supervise(CacheBuilder::Worker[endpoint.type], endpoint_options.merge(priority: index))
      end
    end

    def build
      cache_manager.process_workers(workers)
    end

    # Issue a build command to all workers at the scheduled interval
    #
    # @param [Fixnum, Float] interval
    def build_loop(interval = @build_interval)
      return if @building

      loop do
        @building = true
        build
        sleep interval
      end
    end

    # Return the list of running workers
    #
    # @return [Array<CacheBuilder::Worker::Base>]
    def workers
      @worker_supervisor.actors
    end

    private

      def finalize_callback
        log.info "Cache Builder shutting down..."
        @worker_supervisor.terminate if @worker_supervisor && @worker_supervisor.alive?
      end
  end
end
