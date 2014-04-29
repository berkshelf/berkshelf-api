require 'grape'
require 'grape-msgpack'

module Berkshelf::API
  module Endpoint
    class Base < Grape::API
      # Force inbound requests to be JSON
      def call(env)
        env['CONTENT_TYPE'] = 'application/json'
        # If coming from a browser or other naive HTTP client, we want JSON back
        env['HTTP_ACCEPT'] = 'application/json' if !env['HTTP_ACCEPT'] || env['HTTP_ACCEPT'].include?('text/html')
        super
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/endpoint/*.rb"].sort.each do |path|
  require "berkshelf/api/endpoint/#{File.basename(path, '.rb')}"
end
