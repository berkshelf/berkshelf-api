module Berkshelf::API
  module Logging
    class << self
      # @return [Logger]
      attr_accessor :logger

      # @option options [String, Fixnum] :location (STDOUT)
      # @option options [String, nil] :level ("INFO")
      #   - "DEBUG
      #   - "INFO"
      #   - "WARN"
      #   - "ERROR"
      #   - "FATAL"
      # @option options [Logger::Formatter] :formatter
      #
      # @return [Logger]
      def init(options = {})
        level     = options[:level] || "INFO"
        location  = options[:location] || STDOUT
        formatter = options[:formatter] || nil

        Celluloid.logger = @logger = Logger.new(location).tap do |log|
          log.level     = Logger::Severity.const_get(level.upcase)
          log.formatter = formatter if formatter
        end
      end
    end

    init

    # @return [Logger]
    def logger
      Logging.logger
    end
    alias_method :log, :logger
  end
end
