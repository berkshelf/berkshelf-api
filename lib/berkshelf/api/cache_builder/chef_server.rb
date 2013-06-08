module Berkshelf::API
  module CacheBuilder
    class ChefServer < CacheBuilder::Base
      def initialize(options = {})
        @ridley_sup = Ridley::Client.supervise(options)
      end

      # @return [String]
      def archive_name
        "opscode-site"
      end

      def stale?
        false
      end

      private

        def connection
          @ridley_sup.actors.first
        end
    end
  end
end
