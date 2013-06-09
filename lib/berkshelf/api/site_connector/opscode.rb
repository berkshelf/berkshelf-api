require 'open-uri'
require 'retryable'
require 'archive'

module Berkshelf::API
  module SiteConnector
    class Opscode
      class << self
        # @param [String] version
        #
        # @return [String]
        def uri_escape_version(version)
          version.to_s.gsub('.', '_')
        end
      end

      include Celluloid
      include Berkshelf::API::Logging

      V1_API = 'http://cookbooks.opscode.com/api/v1'.freeze

      # @return [String]
      attr_reader :api_uri
      # @return [Integer]
      #   how many retries to attempt on HTTP requests
      attr_reader :retries
      # @return [Float]
      #   time to wait between retries
      attr_reader :retry_interval

      # @param [Faraday::Connection] connection
      #   Optional parameter for setting the connection object
      #   This should only be set manually for testing
      def initialize(uri = V1_API, options = {})
        options  = { retries: 5, retry_interval: 0.5 }.merge(options)
        @api_uri = uri

        @connection = Faraday.new(uri) do |c|
          c.response :parse_json
          c.use Faraday::Adapter::NetHttp
        end
      end

      # @return [Array<String>]
      #   A list of cookbook names available on the server
      def all_cookbooks
        count     = connection.get("cookbooks?start=0&items=0").body["total"]
        cookbooks = connection.get("cookbooks?start=0&items=#{count}").body["items"]
        cookbooks.map { |cb| cb["cookbook_name"] }
      end

      # @param [String] cookbook
      #   the name of the cookbook to find version for
      #
      # @return [Array<String>]
      #   A list of versions of this cookbook available on the server
      def all_versions(cookbook)
        versions = connection.get("cookbooks/#{cookbook}").body["versions"]
        versions.map { |version| version.split("/").last.gsub("_", ".") }
      end

      # @param [String] cookbook
      #   The name of the cookbook to download
      # @param [String] version
      #   The version of the cookbook to download
      # @param [String] destination
      #   The directory to download the cookbook to
      #
      # @return [String]
      def download(name, version, destination = Dir.mktmpdir)
        log.info "downloading #{name}(#{version})"
        if cookbook = find(name, version)
          archive = stream(cookbook[:file])
          Archive.extract(archive.path, destination)
        end
      ensure
        archive.unlink unless archive.nil?
      end

      # @param [String] cookbook
      #   The name of the cookbook to retrieve
      # @param [String] version
      #   The version of the cookbook to retrieve
      #
      # @return [Hashie::Mash, nil]
      def find(name, version)
        response = connection.get("cookbooks/#{name}/versions/#{self.class.uri_escape_version(version)}")

        case response.status
        when (200..299)
          response.body
        else
          nil
        end
      end

      # Stream the response body of a remote URL to a file on the local file system
      #
      # @param [String] target
      #   a URL to stream the response body from
      #
      # @return [Tempfile]
      def stream(target)
        local = Tempfile.new('opscode-site-stream')
        local.binmode

        retryable(tries: retries, on: OpenURI::HTTPError, sleep: retry_interval) do
          open(target, 'rb', connection.headers) do |remote|
            local.write(remote.read)
          end
        end

        local
      ensure
        local.close(false) unless local.nil?
      end

      private

        attr_reader :connection
    end
  end
end
