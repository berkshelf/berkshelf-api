module Berkshelf::API
  class CacheManager
    class << self
      # @return [String]
      def cache_file
        File.join(Application.home_path, "cerch")
      end
    end

    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging

    extend Forwardable
    def_delegators :@cache, :warmed?, :set_warmed

    SAVE_INTERVAL = 30.0

    server_name :cache_manager
    finalizer :finalize_callback
    exclusive :merge, :add, :remove

    # @return [DependencyCache]
    attr_reader :cache

    def initialize
      log.info "Cache Manager starting..."
      @cache = DependencyCache.new
      load_save if File.exist?(self.class.cache_file)
      every(SAVE_INTERVAL) { save }
    end

    # @param [RemoteCookbook] cookbook
    # @param [Ridley::Chef::Cookbook::Metadata] metadata
    #
    # @return [Hash]
    def add(cookbook, metadata)
      log.debug "#{self} adding (#{cookbook.name}, #{cookbook.version})"
      cache.add(cookbook, metadata)
    end

    # Remove the cached item matching the given name and version
    #
    # @param [#to_s] name
    # @param [#to_s] version
    #
    # @return [DependencyCache]
    def remove(name, version)
      log.debug "#{self} removing (#{name}, #{version})"
      cache.remove(name, version)
    end

    # Loops through a list of workers and merges their cookbook sets into the cache
    #
    # @param [Array<CacheBuilder::Worker::Base>] workers
    #   The workers for this cache
    #
    # @return [Boolean]
    def process_workers(workers)
      # If the cache has been warmed already, we want to spawn
      # workers for all the endpoints concurrently. However, if the
      # cache is cold we want to run sequentially, so higher priority
      # endpoints can work before lower priority, avoiding duplicate
      # downloads.
      # We don't want crashing workers to crash the CacheManager.
      # Crashes are logged so just ignore the exceptions
      if warmed?
        Array(workers).flatten.collect do |worker|
          self.future(:process_worker, worker)
        end.each do |f|
          f.value rescue nil
        end
      else
        Array(workers).flatten.each do |worker|
          process_worker(worker) rescue nil
        end
      end
      self.set_warmed
    end

    # @param [CacheBuilder::Worker::Base] worker
    def process_worker(worker)
      log.info "processing #{worker}"
      remote_cookbooks = worker.cookbooks
      log.info "found #{remote_cookbooks.size} cookbooks from #{worker}"
      created_cookbooks, deleted_cookbooks = diff(remote_cookbooks)
      log.debug "#{created_cookbooks.size} cookbooks to be added to the cache from #{worker}"
      log.debug "#{deleted_cookbooks.size} cookbooks to be removed from the cache from #{worker}"

      # Process metadata in chunks - Ridley cookbook resource uses a
      # task_class TaskThread, which means each future gets its own
      # thread. If we have many (>2000) cookbooks we can easily
      # exhaust the available threads on the system.
      created_cookbooks_with_metadata = []
      until created_cookbooks.empty?
        work = created_cookbooks.slice!(0,500)
        log.info "processing metadata for #{work.size} cookbooks with #{created_cookbooks.size} remaining on #{worker}"
        work.map! do |remote|
          [ remote, worker.future(:metadata, remote) ]
        end.map! do |remote, metadata|
          [remote, metadata.value]
        end
        created_cookbooks_with_metadata += work
      end

      log.info "about to merge cookbooks"
      merge(created_cookbooks_with_metadata, deleted_cookbooks)
      log.info "#{self} cache updated."
    end

    # Clear any items added to the cache
    #
    # @return [Hash]
    def clear
      @cache.clear
    end

    # Check if the cache knows about the given cookbook version
    #
    # @param [#to_s] name
    # @param [#to_s] version
    #
    # @return [Boolean]
    def has_cookbook?(name, version)
      @cache.has_cookbook?(name, version)
    end

    def load_save
      log.info "Loading save from #{self.class.cache_file}"
      @cache = DependencyCache.from_file(self.class.cache_file)
      log.info "Cache contains #{@cache.cookbooks.size} items"
    end

    private

      def merge(created_cookbooks, deleted_cookbooks)
        log.info "#{self} adding (#{created_cookbooks.length}) items..."
        created_cookbooks.each do |remote_with_metadata|
          remote, metadata = remote_with_metadata
          add(remote, metadata)
        end

        log.info "#{self} removing (#{deleted_cookbooks.length}) items..."
        deleted_cookbooks.each { |remote| remove(remote.name, remote.version) }

        log.info "#{self} cache updated."
        save
      end

      def save
        log.info "Saving the cache to: #{self.class.cache_file}"
        cache.save(self.class.cache_file)
        log.info "Cache saved!"
      end

      # @param [Array<RemoteCookbook>] cookbooks
      #   An array of RemoteCookbooks representing all the cookbooks on the indexed site
      #
      # @return [Array(Array<RemoteCookbook>, Array<RemoteCookbook>)]
      #   A tuple of Arrays of RemoteCookbooks
      #   The first array contains items not in the cache
      #   The second array contains items in the cache, but not in the cookbooks parameter
      def diff(cookbooks)
        known_cookbooks   = cache.cookbooks
        created_cookbooks = cookbooks - known_cookbooks
        deleted_cookbooks = known_cookbooks - cookbooks
        [ created_cookbooks, deleted_cookbooks ]
      end

      def finalize_callback
        log.info "Cache Manager shutting down..."
        save
      end
  end
end
