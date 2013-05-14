module Berkshelf::API
  module CacheBuilder
    class << self
      # @raise [Celluloid::DeadActorError] if Cache Builder has not been started
      #
      # @return [Celluloid::Actor(Berkshelf::API::CacheBuilder)]
      def instance
        unless Berkshelf::API::Application[:cache_builder] && Berkshelf::API::Application[:cache_builder].alive?
          raise Berkshelf::NotStartedError, "cache builder not running"
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

    # @author Jamie Winsor <reset@riotgames.com>
    # @author Andrew Garson <agarson@riotgames.com>
    class Base

      INTERVAL = 5

      include Celluloid
      include Berkshelf::API::Mixin::Services

      attr_reader :options

      def initialize(options={})
        @options = options
      end

      # @abstract
      # 
      # @return [#to_s]
      def archive_name
        raise RuntimeError, "must be implemented"
      end

      # @abstract
      #
      # @param [RemoteCookbook] remote
      #
      # @return [Ridley::Chef::Cookbook::Metadata]
      def metadata(remote)
        raise RuntimeError, "must be implemented"
      end

      # @abstract
      #
      # @return [Array<RemoteCookbook>]
      #  The list of cookbooks this builder can find
      def cookbooks
        raise RuntimeError, "must be implemented"
      end

      def build
        loop do
          update_cache if stale?

          sleep INTERVAL
          clear_diff
        end
      end

      # @return [Array<RemoteCookbook>]
      def diff
        @diff ||= cache_manager.diff(cookbooks)
      end

      def update_cache
        created_cookbooks, deleted_cookbooks = diff
        created_cookbooks.collect { |remote| cache_manager.future(:add, remote.name, remote.version, metadata(remote)) }.map(&:value)
        deleted_cookbooks.each { |remote| cache_manager.remove(remote.name, remote.version) }
      end

      def stale?
        created_cookbooks, deleted_cookbooks = diff
        created_cookbooks.any? || deleted_cookbooks.any?
      end

      private

        def clear_diff
          @diff = nil
        end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/cache_builder/*.rb"].sort.each do |path|
  require "berkshelf/api/cache_builder/#{File.basename(path, '.rb')}"
end
