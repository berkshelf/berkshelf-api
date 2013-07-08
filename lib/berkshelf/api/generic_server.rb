module Berkshelf::API
  module GenericServer
    class << self
      def included(base)
        base.send(:include, Celluloid)
        base.send(:extend, ClassMethods)
      end
    end

    module ClassMethods
      # Returns the currently running instance of the including Class
      #
      # @return [Celluloid::Actor]
      def instance
        unless Application[server_name] && Application[server_name].alive?
          raise NotStartedError, "#{server_name} not running"
        end
        Application[server_name]
      end

      # Set the name that the actor will be registered as with the applicaiton
      #
      # @param [#to_sym, nil]
      #
      # @return [Symbol]
      def server_name(name = nil)
        return @server_name if name.nil?
        @server_name = name.to_sym
      end

      # Start the cache manager and add it to the application's registry.
      #
      # @note you probably do not want to manually start the cache manager unless you
      #   are testing the application. Start the entire application with {Berkshelf::API::Application.run}
      def start(*args)
        Application[server_name] = new(*args)
      end

      # Stop the cache manager if it's running.
      #
      # @note you probably don't want to manually stop the cache manager unless you are testing
      #   the application. Stop the entire application with {Berkshelf::API::Application.shutdown}
      def stop
        unless actor = Application[server_name]
          actor.terminate
        end
      end
    end
  end
end
