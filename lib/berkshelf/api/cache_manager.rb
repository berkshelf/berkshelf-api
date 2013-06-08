module Berkshelf::API
  class CacheManager
    class << self
      # @raise [Celluloid::DeadActorError] if Bootstrap Manager has not been started
      #
      # @return [Celluloid::Actor(Berkshelf::API::CacheManager)]
      def instance
        unless Berkshelf::API::Application[:cache_manager] && Berkshelf::API::Application[:cache_manager].alive?
          raise Berkshelf::NotStartedError, "cache manager not running"
        end
        Berkshelf::API::Application[:cache_manager]
      end

      # Start the cache manager and add it to the application's registry.
      #
      # @note you probably do not want to manually start the cache manager unless you
      #   are testing the application. Start the entire application with {Berkshelf::API::Application.run}
      def start
        Berkshelf::API::Application[:cache_manager] = new
      end

      # Stop the cache manager if it's running.
      #
      # @note you probably don't want to manually stop the cache manager unless you are testing
      #   the application. Stop the entire application with {Berkshelf::API::Application.shutdown}
      def stop
        instance.terminate
      rescue Berkshelf::NotStartedError
        nil
      end
    end

    include Celluloid
    include Berkshelf::API::Logging

    finalizer :finalize_callback

    attr_reader :cache

    def initialize
      @cache = DependencyCache.new
      load_save if File.exist?(save_file)
    end

    # @param [String] name
    # @param [String] version
    # @param [Ridley::Chef::Cookbook::Metadata] metadata
    #
    # @return [Hash]
    def add(name, version, metadata)
      cache[name] ||= Hashie::Mash.new
      cache[name][version] = {
        platforms: metadata.platforms,
        dependencies: metadata.dependencies
      }
    end

    def load_save
      @cache = DependencyCache.from_file(save_file)
    end

    # @param [String] name
    # @param [String] version
    #
    # @return [DependencyCache]
    def remove(name, version)
      cache[name].delete(version)
      if cache[name].empty?
        cache.delete(name)
      end
      cache
    end

    def save_file
      File.expand_path("~/.berkshelf/api-server/cerch")
    end

    # @param [Array<RemoteCookbook>] cookbooks
    #   An array of RemoteCookbooks representing all the cookbooks on the indexed site
    #
    # @return [Array<(Array<RemoteCookbook>, Array<RemoteCookbook>)>]
    #   A tuple of Arrays of RemoteCookbooks
    #   The first array contains items not in the cache
    #   The second array contains items in the cache, but not in the cookbooks parameter
    def diff(cookbooks)
      known_cookbooks = cache.cookbooks
      created_cookbooks = cookbooks - known_cookbooks
      deleted_cookbooks = known_cookbooks - cookbooks
      [created_cookbooks, deleted_cookbooks]
    end

    private

      def finalize_callback
        log.info "Cache Manager shutting down..."
        log.info "Saving the cache to: #{save_file}"
        cache.save(save_file)
        log.info "Cache saved!"
      end
  end
end
