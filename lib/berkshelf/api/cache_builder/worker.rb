module Berkshelf::API
  class CacheBuilder
    module Worker
      class Base
        INTERVAL = 5

        include Celluloid
        include Berkshelf::API::Logging
        include Berkshelf::API::Mixin::Services

        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        # @abstract
        #
        # @return [#to_s]
        def archive_name
          raise RuntimeError, "must be implemented"
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

        def build
          return if @building

          loop do
            @building = true
            update_cache if stale?

            sleep INTERVAL
            clear_diff
          end
        end

        # @return [Array<RemoteCookbook>]
        def diff
          @diff ||= cache_manager.diff(cookbooks)
        end

        def update_cache
          created_cookbooks, deleted_cookbooks = diff
          created_cookbooks.collect { |remote| cache_manager.future(:add, remote.name, remote.version, metadata(remote)) }.map(&:value)
          deleted_cookbooks.each { |remote| cache_manager.remove(remote.name, remote.version) }
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
    end
  end
end

Dir["#{File.dirname(__FILE__)}/worker/*.rb"].sort.each do |path|
  require_relative "worker/#{File.basename(path, '.rb')}"
end
