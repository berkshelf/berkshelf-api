require 'httpclient'
require 'retryable'
require 'archive'
require 'tempfile'

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

        # @param [String] uri
        #
        # @return [String]
        def version_from_uri(uri)
          File.basename(uri.to_s).gsub('_', '.')
        end
      end

      include Celluloid
      include Berkshelf::API::Logging

      V1_API = 'http://cookbooks.opscode.com/api/v1'.freeze
      RETRYABLE_ERRORS = [HTTPClient::BadResponseError, HTTPClient::TimeoutError]

      # @return [String]
      attr_reader :api_uri
      # @return [Integer]
      #   how many retries to attempt on HTTP requests
      attr_reader :retries
      # @return [Float]
      #   time to wait between retries
      attr_reader :retry_interval

      # @param [Hash] options
      #   Optional parameters for configuration of retry settings and URL
      def initialize(options = {})
        options  = { url: V1_API, retries: 5, retry_interval: 0.5 }.merge(options)
        @api_uri = options[:url]

        @connection = Faraday.new(@api_uri) do |c|
          c.response :parse_json
          c.use Faraday::Adapter::NetHttp
        end

        @httpclient = HTTPClient.new
        @httpclient.receive_timeout = 300
      end

      # @return [Array<String>]
      #   A list of cookbook names available on the server
      def cookbooks
        start     = 0
        count     = connection.get("cookbooks").body["total"]
        cookbooks = Array.new

        while count > 0
          cookbooks += connection.get("cookbooks?start=#{start}&items=#{count}").body["items"]
          start += 100
          count -= 100
        end

        cookbooks.map { |cb| cb["cookbook_name"] }
      end

      # @param [String] cookbook
      #   the name of the cookbook to find version for
      #
      # @return [Array<String>]
      #   A list of versions of this cookbook available on the server
      def versions(cookbook)
        response = connection.get("cookbooks/#{cookbook}")

        case response.status
        when (200..299)
          response.body['versions'].collect do |version_uri|
            self.class.version_from_uri(version_uri)
          end
        else
          Array.new
        end
      end

      # @param [String] cookbook
      #   The name of the cookbook to download
      # @param [String] version
      #   The version of the cookbook to download
      # @param [String] destination
      #   The directory to download the cookbook to
      #
      # @return [String, nil]
      def download(name, version, destination = Dir.mktmpdir)
        log.debug "downloading #{name}(#{version})"
        if uri = download_uri(name, version)
          archive = stream(uri)
          Archive.extract(archive.path, destination)
        end
      ensure
        archive.unlink unless archive.nil?
      end

      # Return the location where a cookbook of the given name and version can be downloaded from
      #
      # @param [String] cookbook
      #   The name of the cookbook
      # @param [String] version
      #   The version of the cookbook
      #
      # @return [String, nil]
      def download_uri(name, version)
        unless cookbook = find(name, version)
          return nil
        end
        cookbook[:file]
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

        retryable(tries: retries, on: RETRYABLE_ERRORS, sleep: retry_interval) do
          @httpclient.get_content(target) do |content|
            local.write(content)
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
