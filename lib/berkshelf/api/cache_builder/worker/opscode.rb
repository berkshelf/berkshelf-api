module Berkshelf::API
  class CacheBuilder
    module Worker
      class Opscode < Worker::Base
        worker_type "opscode"

        finalizer :finalize_callback

        def initialize(options = {})
          @connection = Berkshelf::API::SiteConnector::Opscode.pool_link(size: 25, args: [ options ])
          super
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          [].tap do |cookbook_versions|
            connection.cookbooks.collect do |cookbook|
              [ cookbook, connection.future(:versions, cookbook) ]
            end.each do |cookbook, versions|
              versions.value.each do |version|
                cookbook_versions << RemoteCookbook.new(cookbook, version, self.class.worker_type, @connection.api_uri, priority)
              end
            end
          end
        end

        # Return the metadata of the given RemoteCookbook. If the metadata could not be found or parsed
        # nil is returned.
        #
        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata, nil]
        def metadata(remote)
          Dir.mktmpdir('metadata') do |destination|
            if connection.download(remote.name, remote.version, destination)
              load_metadata(destination, remote.name)
            end
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
            file = Dir["#{directory}/**/*/metadata.json"].first
            return nil if file.nil?

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
