require 'optparse'

trap 'INT' do
  Berkshelf::API::Application.shutdown
end

trap 'TERM' do
  Berkshelf::API::Application.shutdown
end

module Berkshelf::API
  class ApplicationSupervisor < Celluloid::SupervisionGroup
    def initialize(registry, options = {})
      super(registry)
      supervise_as(:cache_manager, Berkshelf::API::CacheManager)
      supervise_as(:cache_builder, Berkshelf::API::CacheBuilder)
      supervise_as(:rest_gateway, Berkshelf::API::RESTGateway, options)
    end
  end

  module Application
    class << self
      extend Forwardable
      include Berkshelf::API::Logging

      def_delegators :registry, :[], :[]=

      def instance
        return @instance unless @instance.nil?

        raise Celluloid::DeadActorError, "application not running"
      end

      # @param [Array] args
      #
      # @return [Hash]
      def parse_options(args)
        options = Hash.new

        OptionParser.new("Usage: berks-api [options]") do |opts|
          opts.on("-p", "--port PORT", Integer, "set the listening port") do |v|
            options[:port] = v
          end

          opts.on_tail("-h", "--help", "show this message") do
            puts opts
            exit
          end
        end.parse!(args)

        options.symbolize_keys
      end

      # The Actor registry for Berkshelf::API.
      #
      # @note Berkshelf::API uses it's own registry instead of Celluloid::Registry.root to
      #   avoid conflicts in the larger namespace. Use Berkshelf::API::Application[] to access Berkshelf::API
      #   actors instead of Celluloid::Actor[].
      #
      # @return [Celluloid::Registry]
      def registry
        @registry ||= Celluloid::Registry.new
      end

      # Run the application in the foreground (sleep on main thread)
      def run(args = [])
        loop do
          supervisor = run!(args)

          sleep 0.1 while supervisor.alive?

          break if @shutdown

          log.error "!!! #{self} crashed. Restarting..."
        end
      end

      def run!(args = [])
        options   = parse_options(args)
        @instance = ApplicationSupervisor.new(registry, options)
      end

      def shutdown
        @shutdown = true
        instance.terminate
      end
    end
  end
end
