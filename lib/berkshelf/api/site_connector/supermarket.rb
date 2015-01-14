require 'open-uri'
require 'archive'
require 'tempfile'

module OpenURI
  class << self
    #
    # The is a bug in Ruby's implementation of OpenURI that prevents redirects
    # from HTTP -> HTTPS. That should totally be a valid redirect, so we
    # override that method here and call it a day.
    #
    # Note: this does NOT permit HTTPS -> HTTP redirects, as that would be a
    # major security hole in the fabric of space-time!
    #
    def redirectable?(uri1, uri2)
      a, b = uri1.scheme.downcase, uri2.scheme.downcase

      a == b || (a == 'http' && b == 'https')
    end
  end
end

module Berkshelf::API
  module SiteConnector
    class Supermarket
      include Berkshelf::API::Logging

      # The default API server
      V1_API = 'https://supermarket.getchef.com/'.freeze

      # The timeout for the HTTP request
      TIMEOUT = 15

      EMPTY_UNIVERSE = {}.freeze

      # @return [String]
      attr_reader :api_url

      # @option options [String] :url ({V1_API})
      #   url of community site
      def initialize(options = {})
        @api_url = options[:url] || V1_API
      end

      # @return [Hash]
      def universe
        universe_url = URI.parse(File.join(api_url, 'universe.json')).to_s

        log.debug "Loading universe from `#{universe_url}'..."

        Timeout.timeout(TIMEOUT) do
          response = open(universe_url, 'User-Agent' => USER_AGENT)
          JSON.parse(response.read)
        end
      rescue JSON::ParserError => e
        log.error "Failed to parse JSON: #{e}"
        EMPTY_UNIVERSE
      rescue Timeout::Error
        log.error "Failed to get `#{universe_url}' in #{TIMEOUT} seconds!"
        EMPTY_UNIVERSE
      rescue SocketError,
             Errno::ECONNREFUSED,
             Errno::ECONNRESET,
             Errno::ENETUNREACH,
             OpenURI::HTTPError => e
        log.error "Failed to get `#{universe_url}': #{e}"
        EMPTY_UNIVERSE
      end
    end
  end
end
