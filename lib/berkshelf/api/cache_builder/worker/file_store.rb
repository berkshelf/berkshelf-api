module Berkshelf::API
  class CacheBuilder
    module Worker
      class FileStore < Worker::Base
        worker_type "file_store"

        include Logging

        # @return [String]
        attr_reader :path

        # @option options [String] :path
        #   the directory to search for local cookbooks
        def initialize(options = {})
          @path = Pathname(options[:path])
          log.warn "You have configured a FileStore endpoint to index the contents of #{@path}."
          log.warn "Using unfinalized artifacts, which this path may contain, to satisfiy your"
          log.warn "dependencies is *STRONGLY FROWNED UPON* and potentially *DANGEROUS*."
          log.warn ""
          log.warn "Please consider setting up a release process for the cookbooks you wish to retrieve from this"
          log.warn "filepath where the cookbook is uploaded into a Hosted Chef organization, an internal"
          log.warn "Chef Server, or the community site, and then replace this endpoint with a chef_server endpoint."
          super(options)
        end

        # @return [String]
        def to_s
          friendly_name(path)
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          [].tap do |cookbook_versions|
            @path.each_child do |dir|
              next unless dir.cookbook?
              begin
                cookbook = Ridley::Chef::Cookbook.from_path(dir)
                cookbook_versions << RemoteCookbook.new(cookbook.cookbook_name, cookbook.version,
                  self.class.worker_type, cookbook.path, priority)
              rescue => ex
                log.debug ex.message
              end
            end
          end
        end

        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata]
        def metadata(remote)
          load_metadata(remote.location_path)
        end

        private

          # Helper function for loading metadata from a particular directory
          #
          # @param [String] path
          #   path of directory to load from
          #
          # @return [Ridley::Chef::Cookbook::Metadata, nil]
          def load_metadata(path)
            cookbook = Ridley::Chef::Cookbook.from_path(path)
            cookbook.metadata
          rescue => ex
            nil
          end
      end
    end
  end
end
