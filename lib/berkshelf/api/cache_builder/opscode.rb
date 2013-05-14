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

      def cookbooks
        all_cookbooks = connection.all_cookbooks
        slice = options[:get_only] || all_cookbooks.size
        all_cookbooks = all_cookbooks.take(slice)
        all_cookbooks.map do |cookbook|
          versions = connection.all_versions(cookbook)
          versions.map { |version| RemoteCookbook.new(cookbook, version) }
        end.flatten
      end

      def metadata(remote)
        connection.download_meta_data(remote.name, remote.version)
      end

      private
        attr_accessor :connection
    end
  end
end
