module Berkshelf::API
  class APIError < StandardError; end

  # Thrown when an actor was expected to be running but wasn't
  class NotStartedError < APIError; end

  class SaveNotFoundError < APIError; end
  class InvalidSaveError < APIError; end
  class MetadataLoadError < APIError; end
  class ConfigNotFoundError < APIError; end
end
