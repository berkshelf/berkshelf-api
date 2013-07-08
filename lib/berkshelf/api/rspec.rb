require 'berkshelf/api'

module Berkshelf::API
  module RSpec
    require_relative 'rspec/server'

    include Mixin::Services

    def berks_dependency(name, version, options = {})
      options[:platforms] ||= Hash.new
      options[:dependencies] ||= Hash.new
      cookbook = RemoteCookbook.new(name, version,
        CacheBuilder::Worker::Opscode.worker_type, SiteConnector::Opscode::V1_API)
      metadata = Ridley::Chef::Cookbook::Metadata.new
      options[:platforms].each { |name, version| metadata.supports(name, version) }
      options[:dependencies].each { |name, constraint| metadata.depends(name, constraint) }
      cache_manager.add(cookbook, metadata)
    end
  end
end
