module Berkshelf::API
  class RemoteCookbook
    attr_accessor :name
    attr_accessor :version
    attr_accessor :location_type
    attr_accessor :location_path
    attr_accessor :priority
    attr_accessor :info

    def initialize(name, version, location_type, location_path, priority, info = {})
      @name          = name
      @version       = version
      @location_type = location_type
      @location_path = location_path
      @priority      = priority
      @info          = info
    end

    def hash
      "#{name}|#{version}".hash
    end

    def eql?(other)
      self.hash == other.hash
    end
  end
end
