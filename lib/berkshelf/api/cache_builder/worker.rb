module Berkshelf::API
  class CacheBuilder
    module Worker
      class Base
        class << self
          # @param [#to_s, nil] type
          def worker_type(type = nil)
            return @worker_type if @worker_type
            @worker_type = type.to_s
            Worker.register(@worker_type, self)
          end
        end

        include Celluloid
        include Berkshelf::API::Logging
        include Berkshelf::API::Mixin::Services

        attr_reader :options
        attr_reader :priority

        def initialize(options = {})
          @priority = options[:priority]
        end

        # @return [String]
        def to_s
          friendly_name
        end

        # @abstract
        #
        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata]
        def metadata(remote)
          raise RuntimeError, "must be implemented"
        end

        # @abstract
        #
        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          raise RuntimeError, "must be implemented"
        end

        private

          # @param [String] data
          #   any string to append to the worker_type
          # @return [String]
          def friendly_name(data = nil)
            string = self.class.worker_type.dup
            string << ": #{data}" if data
            string
          end
      end

      class << self
        # @param [#to_s] name
        #
        # @return [Worker::Base]
        def [](name)
          types[name.to_s]
        end

        # @param [#to_s] name
        # @param [Worker::Base] klass
        def register(name, klass)
          name = name.to_s
          if types.has_key?(name)
            raise RuntimeError, "worker already registered with the name '#{name}'"
          end
          types[name] = klass
        end

        # @return [Hash]
        def types
          @types ||= Hash.new
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/worker/*.rb"].sort.each do |path|
  require_relative "worker/#{File.basename(path, '.rb')}"
end
