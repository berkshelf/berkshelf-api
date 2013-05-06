require 'berkshelf/api/endpoints'

module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  class RackApp < Grape::API
    mount Berkshelf::API::V1
  end
end
