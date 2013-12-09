require 'octokit'
require 'solve'
require 'net/http'

module Berkshelf::API
  class CacheBuilder
    module Worker
      class Github < Worker::Base
        worker_type "github"

        # @return [String]
        attr_reader :organization

        # @option options [String] :organization
        #   the organization to crawl for cookbooks
        # @option options [String] :access_token
        #   authentication token for accessing the Github organization. This is necessary
        #   since Github throttles unauthenticated API requests
        def initialize(options = {})
          @connection   = Octokit::Client.new(access_token: options[:access_token])
          @organization = options[:organization]
          super(options)
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          [].tap do |cookbook_versions|
            connection.organization_repositories(organization).each do |repo|
              connection.tags(repo.full_name).each do |tag|
                if match = /^v(?<version>.*)$/.match(tag.name)
                  begin
                    next unless cookbook_metadata = load_metadata(repo.name, tag.name)

                    if cookbook_metadata.version.to_s == match[:version].to_s
                      cookbook_versions << RemoteCookbook.new(repo.name, cookbook_metadata.version,
                        self.class.worker_type, repo.full_name, priority)
                    else
                      log.warn "Version found in metadata for #{repo.name} (#{tag.name}) does not " +
                        "match the tag. Got #{cookbook_metadata.version}."
                    end
                  rescue Solve::Errors::InvalidVersionFormat
                    log.debug "Ignoring tag #{tag.name} for: #{repo.name}. Does not conform to semver."
                  rescue Octokit::NotFound
                    log.debug "Ignoring tag #{tag.name} for: #{repo.name}. No raw metadata found."
                  end
                else
                  log.debug "Version number cannot be parsed"
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
          load_metadata(remote.name, "v#{remote.version}")
        end

        private

          attr_reader :connection

          # Helper function for loading metadata from a particular ref in a Github repository
          #
          # @param [String] repo
          #   name of repository to load from
          # @param [String] ref
          #   reference, tag, or branch to load from
          #
          # @return [Ridley::Chef::Cookbook::Metadata, nil]
          def load_metadata(repo, ref)
            metadata_content  = read_content(repo, ref, Ridley::Chef::Cookbook::Metadata::RAW_FILE_NAME)
            cookbook_metadata = Ridley::Chef::Cookbook::Metadata.new
            cookbook_metadata.instance_eval(metadata_content)
            cookbook_metadata
          rescue => ex
            nil
          end

          # Read content from a file from a particular ref in a Github repository
          #
          # @param [String] repo
          #   name of the repository to load from
          # @param [String] ref
          #   reference, tag, or branch to load from
          # @param [String] file
          #   file to read content from
          #
          # @return [String]
          def read_content(repo, ref, file)
            Base64.decode64(connection.contents("#{organization}/#{repo}", path: file, ref: ref).content)
          end
      end
    end
  end
end
