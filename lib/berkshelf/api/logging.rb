module Berkshelf::API
  module Logging
    class << self
      # @return [Logger]
      attr_accessor :logger

      # @option options [String, Fixnum] :location (STDOUT)
      # @option options [String] :level ("INFO")
      #   - "DEBUG
      #   - "INFO"
      #   - "WARN"
      #   - "ERROR"
      #   - "FATAL"
      # @option options [Logger::Formatter] :formatter
      #
      # @return [Logger]
      def init(options = {})
        options = options.reverse_merge(location: STDOUT, level: "INFO")

        Celluloid.logger = @logger = Logger.new(options[:location]).tap do |log|
          log.level     = Logger::Severity.const_get(options[:level])
          log.formatter = options[:formatter] if options[:formatter]
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
