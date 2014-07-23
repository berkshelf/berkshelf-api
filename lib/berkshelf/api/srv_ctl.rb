require 'optparse'
require 'buff/extensions'

module Berkshelf
  module API
    class SrvCtl
      class << self
        # @param [Array] args
        #
        # @return [Hash]
        def parse_options(args, filename)
          options = Hash.new

          OptionParser.new("Usage: #{filename} [options]") do |opts|
            opts.on("-h", "--host HOST", String, "set the listening address") do |h|
              options[:host] = h
            end

            opts.on("-p", "--port PORT", Integer, "set the listening port") do |v|
              options[:port] = v
            end

            opts.on("-V", "--verbose", "run with verbose output") do
              options[:log_level] = "INFO"
            end

            opts.on("-d", "--debug", "run with debug output") do
              options[:log_level] = "DEBUG"
            end

            opts.on("-q", "--quiet", "silence output") do
              options[:log_location] = '/dev/null'
            end

            opts.on("-c", "--config FILE", String, "path to a configuration file to use") do |v|
              options[:config_file] = v
            end

            opts.on("-v", "--version", "show version") do |v|
              require 'berkshelf/api/version'
              puts Berkshelf::API::VERSION
              exit
            end

            opts.on_tail("-h", "--help", "show this message") do
              puts opts
              exit
            end
          end.parse!(args)

          options.symbolize_keys
        end

        # @param [Array] args
        # @param [String] filename
        def run(args, filename)
          options = parse_options(args, filename)
          new(options).start
        end
      end

      attr_reader :options

      # @param [Hash] options
      #   @see {Berkshelf::API::Application.run} for the list of valid options
      def initialize(options = {})
        @options               = options
        @options[:eager_build] = true
      end

      def start
        require 'berkshelf/api'
        Berkshelf::API::Application.run(options)
      end
    end
  end
end
