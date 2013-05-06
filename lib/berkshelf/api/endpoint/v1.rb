module Berkshelf::API
  module Endpoint
    # @author Jamie Winsor <reset@riotgames.com>
    class V1 < Endpoint::Base
      helpers Berkshelf::API::Mixin::Services
      version 'v1', using: :header, vendor: 'berkshelf'
      format :json

      rescue_from Grape::Exceptions::Validation do |e|
        body = MultiJson.encode(status: e.status, message: e.message, param: e.param)
        rack_response(body, e.status, "Content-type" => "application/json")
      end

      desc "list all known cookbooks"
      get 'universe' do
        cache_manager.cache
      end
    end
  end
end
