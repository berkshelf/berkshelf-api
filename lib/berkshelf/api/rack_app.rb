module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  class RackApp < Endpoint::Base
    mount Berkshelf::API::Endpoint::V1
  end
end
