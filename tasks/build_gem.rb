require 'thor'
require "bundler/gem_tasks"

class BuildGem < Thor
  require 'thor/rake_compat'
  namespace "gem"

  include Thor::RakeCompat

  desc "build", "Build berkshelf-api-#{Berkshelf::API::VERSION}.gem into the pkg directory"
  def build
    Rake::Task["build"].invoke
  end

  desc "install", "Build and install berkshelf-api-#{Berkshelf::API::VERSION}.gem into system gems"
  def install
    Rake::Task["install"].invoke
  end

  method_option :github_token,
    type: :string,
    default: ENV["GITHUB_TOKEN"],
    aliases: "-t",
    banner: "TOKEN"
  desc "release", "Create tag v#{Berkshelf::API::VERSION} and build and push berkshelf-api-#{Berkshelf::API::VERSION}.gem to Rubygems"
  def release
    Rake::Task["release"].invoke
  end

  class Spec < Thor
    namespace :spec
    default_task :all

    desc "all", "run all tests"
    def all
      exec "rspec --color --format=documentation spec"
    end
  end
end
