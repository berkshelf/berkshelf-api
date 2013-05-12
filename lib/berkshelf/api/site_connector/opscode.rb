module Berkshelf::API
  module SiteConnector
    # @author Andrew Garson <agarson@riotgames.com>
    class Opscode

      include Celluloid

      # @param [Faraday::Connection] connection 
      #   Optional parameter for setting the connection object
      #   This should only be set manually for testing
      def initialize(connection=nil)
        @connection = connection
        @connection ||= Faraday.new("http://cookbooks.opscode.com") do |c|
          c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
          c.use Faraday::Adapter::NetHttp
        end
      end

      def all_cookbooks
        count = @connection.get("/api/v1/cookbooks?start=0&items=0").body["total"]
        cookbooks = @connection.get("/api/v1/cookbooks?start=0&items=#{count}").body["items"]
        cookbooks.map { |cb| cb["cookbook_name"] }
      end

      def all_versions(cookbook)
        versions = @connection.get("/api/v1/cookbooks/#{cookbook}").body["versions"]
        versions.map { |version| version.split("/").last.gsub("_", ".") }
      end

    end
  end
end
