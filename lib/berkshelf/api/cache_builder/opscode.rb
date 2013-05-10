module Berkshelf::API
  module CacheBuilder
    # @author Jamie Winsor <reset@riotgames.com>
    class Opscode < CacheBuilder::Base
      # @return [String]
      def archive_name
        "opscode-site"
      end

      def stale?
        true
      end

      def cookbooks
        []
      end
    end
  end
end
