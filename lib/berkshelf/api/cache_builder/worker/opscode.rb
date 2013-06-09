module Berkshelf::API
  class CacheBuilder
    module Worker
      class Opscode < Worker::Base
        finalizer :finalize_callback

        def initialize(options = {})
          @connection = Berkshelf::API::SiteConnector::Opscode.pool_link
          super
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          cookbooks = connection.cookbooks
          slice     = options[:get_only] || cookbooks.size
          cookbooks = cookbooks.take(slice)

          cookbooks.map do |cookbook|
            versions = connection.versions(cookbook)
            versions.map { |version| RemoteCookbook.new(cookbook, version) }
          end.flatten
        end

        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata]
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
            # The community site does not enforce the name of the cookbook contained in the archive
            # downloaded and extracted. This will just find the first metadata.json and load it.
            file     = Dir["#{directory}/**/*/metadata.json"].first
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
