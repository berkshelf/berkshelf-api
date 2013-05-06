module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  class DependencyCache
    def initialize
      @cache = Hashie::Mash.new
    end

    def empty?
      @cache.empty?
    end

    def to_hash
      @cache.to_hash
    end

    def to_json(options = {})
      MultiJson.encode(to_hash, options)
    end
  end
end
