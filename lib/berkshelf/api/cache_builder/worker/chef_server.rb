module Berkshelf::API
  class CacheBuilder
    module Worker
      class ChefServer < Worker::Base
        finalizer :finalize_callback

        def initialize(options = {})
          @connection = Ridley::Client.new_link(options)
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
