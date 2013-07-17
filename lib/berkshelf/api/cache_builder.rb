module Berkshelf::API
  class CacheBuilder
    require_relative 'cache_builder/worker'

    class WorkerSupervisor < Celluloid::SupervisionGroup; end

    BUILD_INTERVAL = 5.0

    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging

    server_name :cache_builder
    finalizer :finalize_callback

    def initialize
      log.info "Cache Builder starting..."
      @worker_registry   = Celluloid::Registry.new
      @worker_supervisor = WorkerSupervisor.new(@worker_registry)
      @building          = false

      Application.config.endpoints.each do |endpoint|
        endpoint_options = endpoint.options.to_hash.deep_symbolize_keys
        @worker_supervisor.supervise(CacheBuilder::Worker[endpoint.type], endpoint_options)
      end
    end

    # Issue a single build command to all workers
    #
    # @return [Array]
    def build
      workers.collect { |actor| actor.future(:build) }.map do |f|
        begin
          f.value
        rescue; end
      end
    end

    # Issue a build command to all workers at the scheduled interval
    #
    # @param [Fixnum, Float] interval
    def build_loop(interval = BUILD_INTERVAL)
      return if @building

      loop do
        @building = true
        build
        sleep BUILD_INTERVAL
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
