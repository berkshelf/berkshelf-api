module Berkshelf::API
  class CacheBuilder
    module Worker
      class ChefServer < Worker::Base
        worker_type "chef_server"

        finalizer :finalize_callback

        def initialize(options = {})
          @connection = Ridley::Client.new_link(server_url: options[:url], client_key: options[:client_key],
            client_name: options[:client_name])
          super
        end

        def stale?
          false
        end

        private

          attr_reader :connection

          def finalize_callback
            connection.terminate if connection && connection.alive?
          end
      end
    end
  end
end
