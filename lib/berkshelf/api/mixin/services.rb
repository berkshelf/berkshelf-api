module Berkshelf::API
  module Mixin
    module Services
      class << self
        def included(base)
          base.extend(ClassMethods)
          base.send(:include, ClassMethods)
        end

        def extended(base)
          base.send(:include, ClassMethods)
        end
      end

      module ClassMethods
        # @raise [Celluloid::DeadActorError] if the bootstrap manager has not been started
        #
        # @return [Celluloid::Actor(Berkshelf::API::CacheManager)]
        def cache_manager
          Berkshelf::API::CacheManager.instance
        end

        def rest_gateway
          Berkshelf::API::Application[:rest_gateway]
        end
      end
    end
  end
end
