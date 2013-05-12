module Berkshelf::API
  module CacheBuilder
    # @author Jamie Winsor <reset@riotgames.com>
    class Opscode < CacheBuilder::Base


      # @param [Hash] options The options for this
      # @option options [] :connection A connection object to use - This should probably only be set for testing
      def initialize(options={})
        super
        @connection = options[:connection] || 
          Berkshelf::API::SiteConnector::Opscode.pool
      end

      def archive_name
        "opscode-site"
      end

      def stale?
        true
      end

      def cookbooks
        all_cookbooks = connection.all_cookbooks
        slice = @options[:get_only] || all_cookbooks.size
        all_cookbooks = all_cookbooks.take(slice)
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
