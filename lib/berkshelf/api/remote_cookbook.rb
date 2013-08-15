module Berkshelf::API
  class RemoteCookbook < Struct.new(:name, :version, :location_type, :location_path)
end
