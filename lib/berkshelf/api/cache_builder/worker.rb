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

        def initialize(options = {}); end

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

        def build
          log.info "#{self} building..."
          log.info "#{self} determining if the cache is stale..."
          if stale?
            log.info "#{self} cache is stale."
            update_cache
          else
            log.info "#{self} cache is up to date."
          end

          log.info "clearing diff"
          clear_diff
        end

        # @return [Array<Array<RemoteCookbook>, Array<RemoteCookbook>>]
        def diff
          @diff ||= cache_manager.diff(cookbooks)
        end

        def update_cache
          created_cookbooks, deleted_cookbooks = diff

          log.info "#{self} adding (#{created_cookbooks.length}) items..."
          created_cookbooks.collect do |remote|
            [ remote, future(:metadata, remote) ]
          end.each do |remote, metadata|
            cache_manager.add(remote, metadata.value)
          end

          log.info "#{self} removing (#{deleted_cookbooks.length}) items..."
          deleted_cookbooks.each { |remote| cache_manager.remove(remote.name, remote.version) }

          log.info "#{self} cache updated."
          cache_manager.save
        end

        def stale?
          created_cookbooks, deleted_cookbooks = diff
          created_cookbooks.any? || deleted_cookbooks.any?
        end

        private

          def clear_diff
            @diff = nil
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
