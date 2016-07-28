require 'berkshelf/api/version'
require 'celluloid'
require 'hashie'
require 'ridley'
require 'json'

require_relative 'api/core_ext'

module Berkshelf
  module API
    Encoding.default_external = Encoding::UTF_8

    USER_AGENT = "Berkshelf API v#{Berkshelf::API::VERSION}".freeze

    require_relative 'api/errors'
    require_relative 'api/logging'
    require_relative 'api/mixin'
    require_relative 'api/generic_server'

    require_relative 'api/application'
    require_relative 'api/cache_builder'
    require_relative 'api/cache_manager'
    require_relative 'api/config'
    require_relative 'api/dependency_cache'
    require_relative 'api/endpoint'
    require_relative 'api/rack_app'
    require_relative 'api/remote_cookbook'
    require_relative 'api/site_connector'
    require_relative 'api/srv_ctl'
  end
end

Celluloid.logger.level = Logger::ERROR
