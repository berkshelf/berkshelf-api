module Berkshelf::API
  class CacheBuilder
    module Worker
      class Opscode < Worker::Base
        finalizer :finalize_callback

        def initialize(options = {})
          @connection = Berkshelf::API::SiteConnector::Opscode.pool_link
          super
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
          Dir.mktmpdir do |destination|
            connection.download(remote.name, remote.version, destination)
            load_metadata(destination, remote.name)
          end
        end

        private

          attr_accessor :connection

          def finalize_callback
            connection.terminate if connection && connection.alive?
          end

          def load_metadata(directory, cookbook)
            file     = File.join(directory, cookbook, "metadata.json")
            metadata = File.read(file)
            Ridley::Chef::Cookbook::Metadata.from_json(metadata)
          rescue JSON::ParserError => ex
            log.warn "Error loading metadata for #{cookbook} from: #{file}"
            abort MetadataLoadError.new(ex)
          end
      end
    end
  end
end
