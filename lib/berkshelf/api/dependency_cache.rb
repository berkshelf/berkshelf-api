module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  class DependencyCache
    class << self
      # Read an archived cache and re-instantiate it
      #
      # @param [#to_s] filepath
      #   path to an archived cache
      #
      # @raise [Berkshelf::SaveNotFoundError]
      # @raise [Berkshelf::InvalidSaveError]
      #
      # @return [DependencyCache]
      def from_file(filepath)
        contents = MultiJson.decode(File.read(filepath.to_s))
        new(contents)
      rescue Errno::ENOENT => ex
        raise Berkshelf::SaveNotFoundError.new(ex)
      rescue MultiJson::LoadError => ex
        raise Berkshelf::InvalidSaveError.new(ex)
      end
    end

    # @param [Hash] contents
    def initialize(contents = {})
      @cache = Hashie::Mash.new(contents)
    end

    # @return [Boolean]
    def empty?
      @cache.empty?
    end

    # @return [Hash]
    def to_hash
      @cache.to_hash
    end

    # @return [String]
    def to_json(options = {})
      MultiJson.encode(to_hash, options)
    end
  end
end
