module Berkshelf::API
  class CacheBuilder
    module Worker
      class ChefServer < Worker::Base
        finalizer :finalize_callback

        def initialize(options = {})
          super
          @connection = Ridley::Client.new_link(options)
        end

        # @return [String]
        def archive_name
          "opscode-site"
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
