module Berkshelf::API
  class CacheBuilder
    module Worker
      class FileStore < Worker::Base
        worker_type "file_store"

        # @return [String]
        attr_reader :path

        # @option options [String] :path
        #   the directory to search for local cookbooks
        def initialize(options = {})
          @path = Pathname(options[:path])
          super(options)
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          [].tap do |cookbook_versions|
            @path.each_child do |dir|
              next unless dir.directory?
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
            metadata_content  = File.read(File.join(path, Ridley::Chef::Cookbook::Metadata::RAW_FILE_NAME))
            cookbook_metadata = Ridley::Chef::Cookbook::Metadata.new
            cookbook_metadata.instance_eval(metadata_content)
            cookbook_metadata
          rescue => ex
            nil
          end
      end
    end
  end
end
