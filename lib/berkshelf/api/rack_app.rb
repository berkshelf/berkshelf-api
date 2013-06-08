module Berkshelf::API
  class RackApp < Endpoint::Base
    mount Berkshelf::API::Endpoint::V1
  end
end
