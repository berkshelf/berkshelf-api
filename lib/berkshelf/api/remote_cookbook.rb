module Berkshelf::API
  class RemoteCookbook < Struct.new(:name, :version, :location_type, :location_path, :priority, :external_id)
    def hash
      "#{name}|#{version}".hash
    end

    def eql?(other)
      self.hash == other.hash
    end
  end
end
