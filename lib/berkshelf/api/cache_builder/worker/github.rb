require 'octokit'
require 'solve'
require 'net/http'

module Berkshelf::API
  class CacheBuilder
    module Worker
      class Github < Worker::Base
        worker_type "github"

        def initialize(options = {})
          @connection   = Octokit::Client.new(access_token: options[:access_token])
          @organization = options[:organization]
          super
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          [].tap do |cookbook_versions|
            @connection.organization_repositories(@organization).each do |repo|
              @connection.tags(repo.full_name).each do |tag|
                if match = /^v(?<version>.*)$/.match(tag.name)
                  begin
                    version = Solve::Version.new(match[:version])
                    cookbook_metadata = Ridley::Chef::Cookbook::Metadata.new
                    metadata_content = Base64.decode64(@connection.contents(repo.full_name, path: 'metadata.rb', ref: tag.name).content)
                    cookbook_metadata.instance_eval(metadata_content)
                    if cookbook_metadata.version == match[:version]
                      cookbook_versions << RemoteCookbook.new(repo.name, cookbook_metadata.version, self.class.worker_type, repo.full_name, priority)
                      log.debug "Repository #{repo.name} looks like it has a good tag name, #{tag.name}, #{cookbook_metadata.version}"
                    else
                      log.warn "There is a conflicting tag name for: #{repo.name}, Tag: #{tag.name}, does not match the metadata version #{cookbook_metadata.version}"
                    end
                  rescue Solve::Errors::InvalidVersionFormat => e
                    log.debug "Ignoring tag #{tag.name} for: #{repo.name} as it doesn not conform to semver"
                  rescue Octokit::NotFound => e
                    log.debug "Ignoring tag #{tag.name} for: #{repo.name} as it doesnt seem to have a metadata.rb"
                  end
                else
                  log.debug 'Version number cannot be parsed'
                end
              end
            end
          end
        end

        # Return the metadata of the given RemoteCookbook. If the metadata could not be found or parsed
        # nil is returned.
        #
        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata, nil]
        def metadata(remote)
          cookbook_metadata = Ridley::Chef::Cookbook::Metadata.new
          metadata_content  = Base64.decode64(@connection.contents("#{@organization}/#{remote.name}", path: 'metadata.rb', ref: "v#{remote.version}").content)
          begin
            cookbook_metadata.instance_eval(metadata_content)
            cookbook_metadata
          rescue Exception
            nil
          end
        end
      end
    end
  end
end
