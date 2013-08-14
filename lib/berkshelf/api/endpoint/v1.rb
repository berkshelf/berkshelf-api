module Berkshelf::API
  module Endpoint
    class V1 < Endpoint::Base
      helpers Berkshelf::API::Mixin::Services
      version 'v1', using: :header, vendor: 'berkshelf'
      format :json

      rescue_from Grape::Exceptions::Validation do |e|
        body = JSON.generate({status: e.status, message: e.message, param: e.param})
        rack_response(body, e.status, "Content-type" => "application/json")
      end

      desc "list all known cookbooks"
      get 'universe' do
        if cache_manager.warmed?
          cache_manager.cache
        else
          header "Retry-After", 600
          status 503
        end
      end
    end
  end
end
