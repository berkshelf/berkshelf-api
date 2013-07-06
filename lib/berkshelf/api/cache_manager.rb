module Berkshelf::API
  class CacheManager
    class << self
      attr_writer :cache_file

      # @return [String]
      def cache_file
        @cache_file ||= File.expand_path("~/.berkshelf/api-server/cerch")
      end
    end

    include Berkshelf::API::GenericServer
    include Berkshelf::API::Logging

    SAVE_INTERVAL = 30.0

    server_name :cache_manager
    finalizer :finalize_callback

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
      @cache.add(cookbook, metadata)
    end

    # Clear any items added to the cache
    #
    # @return [Hash]
    def clear
      @cache.clear
    end

    def load_save
      @cache = DependencyCache.from_file(self.class.cache_file)
    end

    # @param [String] name
    # @param [String] version
    #
    # @return [DependencyCache]
    def remove(name, version)
      @cache.remove(name, version)
    end

    def save
      log.info "Saving the cache to: #{self.class.cache_file}"
      cache.save(self.class.cache_file)
      log.info "Cache saved!"
    end

    # @param [Array<RemoteCookbook>] cookbooks
    #   An array of RemoteCookbooks representing all the cookbooks on the indexed site
    #
    # @return [Array<Array<RemoteCookbook>, Array<RemoteCookbook>>]
    #   A tuple of Arrays of RemoteCookbooks
    #   The first array contains items not in the cache
    #   The second array contains items in the cache, but not in the cookbooks parameter
    def diff(cookbooks)
      known_cookbooks   = cache.cookbooks
      created_cookbooks = cookbooks - known_cookbooks
      deleted_cookbooks = known_cookbooks - cookbooks
      [ created_cookbooks, deleted_cookbooks ]
    end

    private

      def finalize_callback
        log.info "Cache Manager shutting down..."
        self.save
      end
  end
end
