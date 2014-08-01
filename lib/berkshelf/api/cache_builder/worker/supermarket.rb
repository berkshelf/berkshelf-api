module Berkshelf::API
  class CacheBuilder
    module Worker
      class Supermarket < Worker::Base
        worker_type 'supermarket'

        # @param [Hash] options
        #   see {API::SiteConnector::Supermarket.new} for options
        def initialize(options = {})
          @connection = Berkshelf::API::SiteConnector::Supermarket.new(options)
          super
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          connection.universe.inject([]) do |list, (name, versions)|
            versions.each do |version, info|
              list << RemoteCookbook.new(name, version, self.class.worker_type, info["location_path"], priority, info)
            end

            list
          end
        end

        # Return the metadata of the given RemoteCookbook. If the metadata could not be found or parsed
        # nil is returned.
        #
        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata, nil]
        def metadata(remote)
          Ridley::Chef::Cookbook::Metadata.from_hash(
            'name'         => remote.name,
            'version'      => remote.version,
            'dependencies' => remote.info['dependencies'] || {},
          )
        end

        private

          attr_accessor :connection
      end
    end
  end
end
