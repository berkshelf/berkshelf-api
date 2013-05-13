module Berkshelf::API
  module CacheBuilder
    # @author Jamie Winsor <reset@riotgames.com>
    class Opscode < CacheBuilder::Base

      def initialize(options={})
        super
        @connection = Berkshelf::API::SiteConnector::Opscode.pool_link
      end

      def archive_name
        "opscode-site"
      end

      def stale?
        true
      end

      def cookbooks
        all_cookbooks = connection.all_cookbooks
        slice = options[:get_only] || all_cookbooks.size
        all_cookbooks = all_cookbooks.take(slice)
        puts "ALL: #{all_cookbooks}"
        all_cookbooks.map do |cookbook|
          versions = connection.all_versions(cookbook)
          versions.map { |version| RemoteCookbook.new(cookbook, version) }
        end.flatten
      end

      def metadata(remote)
        CookbookMetadata.new([], {})
      end

      private
        attr_accessor :connection
    end
  end
end
