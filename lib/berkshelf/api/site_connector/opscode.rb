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

      def all_cookbooks
        count = connection.get("/api/v1/cookbooks?start=0&items=0").body["total"]
        cookbooks = connection.get("/api/v1/cookbooks?start=0&items=#{count}").body["items"]
        cookbooks.map { |cb| cb["cookbook_name"] }
      end

      def all_versions(cookbook)
        versions = connection.get("/api/v1/cookbooks/#{cookbook}").body["versions"]
        versions.map { |version| version.split("/").last.gsub("_", ".") }
      end

      def download_meta_data(cookbook, version)
        version_data = connection.get("/api/v1/cookbooks/#{cookbook}/versions/#{version.gsub(".", "_")}").body
        uri = version_data["file"]
        tgz = StringIO.new(Faraday.get(uri).body)
        tar = ungzip(tgz)
        Dir.mktmpdir do |destination|
          untar(tar, destination)
          get_metadata(destination)
        end
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
                  f.print tarfile.read
                end
              end
            end
          end
        end

        def get_metadata(directory)
          cookbook_root = Pathname.new(directory).children.first
          metadata_file = cookbook_root.join("metadata.rb")
          require 'pry'
          binding.pry
          Ridley::Chef::Cookbook::Metadata.from_file(metadata_file)
        end
    end
  end
end
