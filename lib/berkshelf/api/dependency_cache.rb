module Berkshelf::API
  # @author Jamie Winsor <reset@riotgames.com>
  # @author Andrew Garson <agarson@riotgames.com>
  #
  # @note
  #   DependencyCache stores its data internally as a Mash
  #   The structure is as follows
  #
  #   { 
  #     "cookbook_name" => {
  #       "x.y.z" => {
  #         :dependencies => { "cookbook_name" => "constraint" },
  #         :platforms => { "platform" => "constraint" }
  #       }
  #     }
  #   }
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

    extend Forwardable
    def_delegators :@cache, :[], :[]=

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

    # @return [Array<RemoteCookbook>]
    def cookbooks
      remote_cookbooks = []
      @cache.keys.each do |cookbook_name|
        @cache[cookbook_name].keys.each do |version|
          remote_cookbooks << RemoteCookbook.new(cookbook_name, version)
        end
      end
      remote_cookbooks
    end
  end
end
