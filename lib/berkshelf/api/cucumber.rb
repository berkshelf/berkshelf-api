require_relative 'rspec'

World(Berkshelf::API::RSpec)

Given(/^the Berkshelf API server's cache is up to date$/) do
  cache_builder.build
end

Given(/^the Berkshelf API server's cache is empty$/) do
  cache_manager.clear
end
