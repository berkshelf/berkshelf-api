module Berkshelf::API
  module Endpoint
    class Base < Grape::API
      # Force inbound requests to be JSON
      def call(env)
        env['CONTENT_TYPE'] = 'application/json'
        super
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/endpoint/*.rb"].sort.each do |path|
  require "berkshelf/api/endpoint/#{File.basename(path, '.rb')}"
end
