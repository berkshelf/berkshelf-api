module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
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

    attr_reader :cache

    def initialize
      @cache       = DependencyCache.new
      load_save if File.exist?(save_file)
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

    def load_save
      @cache = DependencyCache.from_file(save_file)
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

    def save_file
      "~/.berkshelf/cerch"
    end

    # @param [Array<RemoteCookbook>] 
    #
    # @return [Array<(Array<RemoteCookbook>, Array<RemoteCookbook>)>]
    def diff(cookbooks)
      [[],[]]
    end
  end
end
