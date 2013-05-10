module Berkshelf::API
  module CacheBuilder
    # @author Jamie Winsor <reset@riotgames.com>
    class Base
      INTERVAL = 5

      include Celluloid
      include Berkshelf::API::Mixin::Services

      def initialize
      end

      # @abstract
      # 
      # @return [#to_s]
      def archive_name
        raise RuntimeError, "must be implemented"
      end

      # @param [RemoteCookbook] remote
      #
      # @return [Ridley::Chef::Cookbook::Metadata]
      def metadata(remote)
        raise RuntimeError, "must be implemented"
      end

      # @abstract
      #
      # @return [Array<RemoteCookbook>]
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
        diff.collect { |remote| cache_manager.future(:add, remote, metadata(remote)) }.map(&:value)
      end

      def stale?
        diff.any?
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
