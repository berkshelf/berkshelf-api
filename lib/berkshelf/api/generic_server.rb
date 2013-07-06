module Berkshelf::API
  module GenericServer
    class << self
      def included(base)
        base.send(:include, Celluloid)
        base.send(:extend, ClassMethods)
      end
    end

    module ClassMethods
      def server_name(name = nil)
        return @server_name if name.nil?
        @server_name = name
      end

      # Start the cache manager and add it to the application's registry.
      #
      # @note you probably do not want to manually start the cache manager unless you
      #   are testing the application. Start the entire application with {Berkshelf::API::Application.run}
      def start(*args)
        Berkshelf::API::Application[server_name] = new(*args)
      end

      # Stop the cache manager if it's running.
      #
      # @note you probably don't want to manually stop the cache manager unless you are testing
      #   the application. Stop the entire application with {Berkshelf::API::Application.shutdown}
      def stop
        unless actor = Berkshelf::API::Application[server_name]
          actor.terminate
        end
      end
    end
  end
end
