require 'grape'
require 'celluloid'
require 'multi_json'
require 'hashie'

module Berkshelf
  # @author Jamie Winsor <reset@riotgames.com>
  module API
    autoload :Application, 'berkshelf/api/application'
    autoload :CacheManager, 'berkshelf/api/cache_manager'
    autoload :DependencyCache, 'berkshelf/api/dependency_cache'
    autoload :Endpoint, 'berkshelf/api/endpoint'
    autoload :Mixin, 'berkshelf/api/mixin'
    autoload :RackApp, 'berkshelf/api/rack_app'
    autoload :RESTGateway, 'berkshelf/api/rest_gateway'
  end
end

require 'berkshelf/api/errors'
require 'berkshelf/api/endpoints'
