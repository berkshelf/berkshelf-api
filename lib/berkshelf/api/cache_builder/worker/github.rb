require 'octokit'
require 'semverse'
require 'net/http'

module Berkshelf::API
  class CacheBuilder
    module Worker
      class Github < Worker::Base
        worker_type "github"

        include Logging

        # @return [String]
        attr_reader :organization

        # @option options [String] :organization
        #   the organization to crawl for cookbooks
        # @option options [String] :access_token
        #   authentication token for accessing the Github organization. This is necessary
        #   since Github throttles unauthenticated API requests
        def initialize(options = {})
          @connection   = Octokit::Client.new(access_token: options[:access_token], auto_paginate: true,
            api_endpoint: options[:api_endpoint], web_endpoint: options[:web_endpoint],
            connection_options: {ssl: {verify: options[:ssl_verify].nil? ? true : options[:ssl_verify]}})
          @organization = options[:organization]

          log.warn "You have configured a GitHub endpoint to index the #{@organization} organization."
          log.warn "Using unfinalized artifacts, such as cookbooks retrieved from Git, to satisfiy your"
          log.warn "dependencies is *STRONGLY FROWNED UPON* and potentially *DANGEROUS*."
          log.warn ""
          log.warn "Please consider setting up a release process for the cookbooks you wish to retrieve from this"
          log.warn "GitHub organization where the cookbook is uploaded into a Hosted Chef organization, an internal"
          log.warn "Chef Server, or the community site, and then replace this endpoint with a chef_server endpoint."

          super(options)
        end

        # @return [String]
        def to_s
          friendly_name(organization)
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
                      cookbook_versions << RemoteCookbook.new(cookbook_metadata.name, cookbook_metadata.version,
                        self.class.worker_type, repo.html_url, priority, {:repo_name => repo.name} )
                    else
                      log.warn "Version found in metadata for #{repo.name} (#{tag.name}) does not " +
                        "match the tag. Got #{cookbook_metadata.version}."
                    end
                  rescue Semverse::InvalidVersionFormat
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
          load_metadata(remote.info[:repo_name], "v#{remote.version}")
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
