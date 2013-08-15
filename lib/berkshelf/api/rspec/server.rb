module Berkshelf::API::RSpec
  module Server
    class << self
      include Berkshelf::API::Mixin::Services

      def clear_cache
        cache_manager.clear
      end

      def instance
        Berkshelf::API::Application.instance
      end

      def running?
        Berkshelf::API::Application.running?
      end

      def start(options = {})
        options = options.reverse_merge(port: 26210, log_location: "/dev/null", endpoints: [])
        Berkshelf::API::Application.config.endpoints = options[:endpoints]
        unless running?
          Berkshelf::API::Application.run!(options)
          cache_builder.build
        end
      end

      def stop
        Berkshelf::API::Application.shutdown
      end
    end
  end
end
