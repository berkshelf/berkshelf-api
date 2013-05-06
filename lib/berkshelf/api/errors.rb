module Berkshelf
  # Thrown when an actor was expected to be running but wasn't
  class NotStartedError < StandardError; end
  class SaveNotFoundError < StandardError; end
  class InvalidSaveError < StandardError; end
end
