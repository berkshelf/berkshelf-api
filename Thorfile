# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
$:.push File.expand_path("../tasks", __FILE__)

require 'bundler'
require 'bundler/setup'
require 'thor'
require 'berkshelf-api'
require 'octokit'
require 'berkflow/thor_tasks'
require 'build_gem'

class Default < Thor
  include Thor::Actions
  namespace "build"
  default_task :all

  GITHUB_ORG_REGEX = /(git\@github.com\:|https\:\/\/github.com\/)(.+)(.git)?/.freeze
  PKG_DIR          = File.expand_path("../pkg", __FILE__).freeze
  VENDOR_DIR       = File.expand_path("../vendor", __FILE__).freeze
  PROJECT_DIR      = File.dirname(__FILE__)

  desc "all", "clean, package, and release to Github"
  def all
    clean
    package
    release
  end

  desc "clean", "clean the packaging directory"
  def clean
    say "cleaning..."
    [ PKG_DIR, VENDOR_DIR ].each do |dir|
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p(dir)
    end
  end

  desc "package", "package the software for release"
  def package
    say "packaging..."
    empty_directory PKG_DIR
    invoke "gem:build"
    inside(File.dirname(__FILE__)) do
      unless File.exist?(File.join("vendor", "cache"))
        error "Gem cache is missing. Run 'bundle package --all' and then repackage."
        exit(1)
      end
      files = `git ls-files | grep -v spec/`.split("\n")
      run("tar -czf #{archive_out} #{files.join(' ')} vendor")
    end
  end

  method_option :github_token,
    type: :string,
    default: ENV["GITHUB_TOKEN"],
    required: true,
    aliases: "-t",
    banner: "TOKEN"
  desc "release", "release the packaged software to Github"
  def release
    say "releasing..."
    begin
      invoke "gem:release"
    rescue => ex
      raise ex unless ex.message.scan(/Repushing of gem versions is not allowed/).any?
    end

    begin
      release = github_client.create_release(repository, version)
    rescue Octokit::UnprocessableEntity
      release = github_client.releases(repository).find { |release| release[:tag_name] == version }
    end

    say "Uploading #{File.basename(archive_out)} to Github..."
    github_client.upload_asset(release[:url], archive_out, name: "berkshelf-api.tar.gz",
      content_type: "application/x-tar")
    invoke Berkflow::ThorTasks, "release", [], berksfile: File.join(PROJECT_DIR, "cookbook", "Berksfile")
  end

  private

    def archive_out
      File.join(PKG_DIR, "berkshelf-api-#{version}.tar.gz")
    end

    def github_client
      @github_client ||= Octokit::Client.new(access_token: options[:github_token])
    end

    def repository
      @repository ||= extract_repository
    end

    def extract_repository
      _, repository = `git remote show origin | grep Push`.scan(GITHUB_ORG_REGEX).first
      repository
    end

    def version
      "v#{Berkshelf::API::VERSION}"
    end
end
