require 'buff/config/json'

module Berkshelf::API
  class Config < Buff::Config::JSON
    class << self
      # @return [String]
      def default_path
        home_path = ENV['BERKSHELF_API_PATH'] || "~/.berkshelf/api-server"
        File.expand_path(File.join(home_path, "config.json"))
      end
    end

    attribute 'home_path',
      type: String,
      default: File.expand_path("~/.berkshelf/api-server")

    attribute 'endpoints',
      type: Array,
      default: [
        {
          type: "opscode",
          options: {
            url: 'http://cookbooks.opscode.com/api/v1'
          }
        }
      ]
  end
end
