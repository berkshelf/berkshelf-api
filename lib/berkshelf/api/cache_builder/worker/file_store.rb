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
