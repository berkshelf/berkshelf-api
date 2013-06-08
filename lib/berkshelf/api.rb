require 'grape'
require 'celluloid'
require 'multi_json'
require 'hashie'
require 'faraday'
require 'faraday_middleware'
require 'zlib'
require 'rubygems/package'
require 'ridley'
require 'tempfile'
require 'pathname'

module Berkshelf
  module API
    autoload :Application, 'berkshelf/api/application'
    autoload :CacheBuilder, 'berkshelf/api/cache_builder'
    autoload :CacheManager, 'berkshelf/api/cache_manager'
    autoload :DependencyCache, 'berkshelf/api/dependency_cache'
    autoload :Endpoint, 'berkshelf/api/endpoint'
    autoload :Mixin, 'berkshelf/api/mixin'
    autoload :RackApp, 'berkshelf/api/rack_app'
    autoload :RemoteCookbook, 'berkshelf/api/remote_cookbook'
    autoload :CookbookMetadata, 'berkshelf/api/cookbook_metadata'
    autoload :RESTGateway, 'berkshelf/api/rest_gateway'
    autoload :SiteConnector, 'berkshelf/api/site_connector'
  end
end

require 'berkshelf/api/errors'
