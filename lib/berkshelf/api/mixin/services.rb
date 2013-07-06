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
        # @raise [Berkshelf::API::NotStartedError] if the cache manager has not been started
        #
        # @return [Berkshelf::API::CacheBuilder]
        def cache_builder
          app_actor(:cache_builder)
        end

        # @raise [Berkshelf::API::NotStartedError] if the cache manager has not been started
        #
        # @return [Berkshelf::API::CacheManager]
        def cache_manager
          app_actor(:cache_manager)
        end

        # @raise [Berkshelf::API::NotStartedError] if the rest gateway has not been started
        #
        # @return [Berkshelf::API::RESTGateway]
        def rest_gateway
          app_actor(:rest_gateway)
        end

        private

          def app_actor(id)
            unless Application[id] && Application[id].alive?
              raise NotStartedError, "#{id} not running"
            end
            Application[id]
          end
      end
    end
  end
end
