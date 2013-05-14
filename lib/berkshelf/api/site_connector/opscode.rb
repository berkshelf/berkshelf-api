module Berkshelf::API
  module SiteConnector
    # @author Andrew Garson <agarson@riotgames.com>
    class Opscode

      include Celluloid

      attr_reader :connection

      # @param [Faraday::Connection] connection 
      #   Optional parameter for setting the connection object
      #   This should only be set manually for testing
      def initialize()
        @connection = Faraday.new("http://cookbooks.opscode.com") do |c|
          c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
          c.use Faraday::Adapter::NetHttp
        end
      end

      # @return [Array<String>]
      #   A list of cookbook names available on the server
      def all_cookbooks
        count = connection.get("/api/v1/cookbooks?start=0&items=0").body["total"]
        cookbooks = connection.get("/api/v1/cookbooks?start=0&items=#{count}").body["items"]
        cookbooks.map { |cb| cb["cookbook_name"] }
      end

      # @param [String] cookbook
      #   the name of the cookbook to find version for
      #
      # @return [Array<String>]
      #   A list of versions of this cookbook available on the server
      def all_versions(cookbook)
        versions = connection.get("/api/v1/cookbooks/#{cookbook}").body["versions"]
        versions.map { |version| version.split("/").last.gsub("_", ".") }
      end

      # @param [String] cookbook 
      #   The name of the cookbook to download
      # @param [String] version 
      #   The version of the cookbook to download
      # @param [String] destination
      #   The directory to download the cookbook to
      #
      # @return [void]
      def download(cookbook, version, destination)
        version_data = connection.get("/api/v1/cookbooks/#{cookbook}/versions/#{version.gsub(".", "_")}").body
        uri = version_data["file"]
        tgz = StringIO.new(Faraday.get(uri).body)
        tar = ungzip(tgz)
        untar(tar, destination)
      end

      private

        # Shamelessly stolen from 
        # https://gist.github.com/sinisterchipmunk/1335041
        def ungzip(tarfile)
          z = Zlib::GzipReader.new(tarfile)
          unzipped = StringIO.new(z.read)
          z.close
          unzipped
        end

        # Shamelessly stolen from 
        # https://gist.github.com/sinisterchipmunk/1335041
        def untar(io, destination)
          Gem::Package::TarReader.new io do |tar|
            tar.each do |tarfile|
              destination_file = File.join destination, tarfile.full_name
              if tarfile.directory?
                FileUtils.mkdir_p destination_file
              else
                destination_directory = File.dirname(destination_file)
                FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
                File.open destination_file, "wb" do |f|
                  f.write tarfile.read
                end
              end
            end
          end
        end
    end
  end
end
