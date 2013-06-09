module Berkshelf::API
  class APIError < StandardError; end
  # Thrown when an actor was expected to be running but wasn't
  class NotStartedError < APIError; end
  class SaveNotFoundError < APIError; end
  class InvalidSaveError < APIError; end

  class UnknownCompressionType < APIError
    def initialize(destination)
      @destination = destination
    end

    def to_s
      "The file at '#{@destination}' is not a known compression type"
    end
  end

  class MetadataLoadError < APIError; end
end
