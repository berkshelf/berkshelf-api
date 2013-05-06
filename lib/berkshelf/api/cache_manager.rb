module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  class CacheManager
    class << self
      # @raise [Celluloid::DeadActorError] if Bootstrap Manager has not been started
      #
      # @return [Celluloid::Actor(Berkshelf::API::CacheManager)]
      def instance
        Berkshelf::API::Application[:cache_manager] or raise Celluloid::DeadActorError, "cache manager not running"
      end

      # Start the cache manager and add it to the application's registry.
      #
      # @note you probably do not want to manually start the cache manager unless you
      #   are testing the application. Start the entire application with {Berkshelf::API::Application.run}
      def start
        Berkshelf::API::Application[:cache_manager] = new
      end
    end

    include Celluloid

    attr_reader :cache

    def initialize
      @cache = DependencyCache.new
    end

    # @param [String] name
    # @param [String] version
    # @param [Ridley::Chef::Cookbook::Metadata] metadata
    #
    # @return [Hash]
    def add(name, version, metadata)
      @cache[name] ||= Hashie::Mash.new
      @cache[name][version] = {
        platforms: metadata.platforms,
        dependencies: metadata.dependencies
      }
    end

    # @param [String] name
    # @param [String] version
    #
    # @return [DependencyCache]
    def remove(name, version)
      @cache[name].delete(version)
      if @cache[name].empty?
        @cache.delete(name)
      end
      @cache
    end
  end
end
