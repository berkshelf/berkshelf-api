require 'gitlab_client'
require 'semverse'

module Berkshelf::API
  class CacheBuilder
    module Worker
      class Gitlab < Worker::Base
        worker_type 'gitlab'

        # @return [String]
        attr_reader :group

        # @option options [String] :group
        #   the group to crawl for cookbooks
        # @option options [String] :url
        #   the api URL, usually something like https://gitlab.example.com
        # @option options [String] :private_token
        #   authentication token for accessing GitLab.
        def initialize(options = {})
          @gitlab_url           = options[:url]
          @group                = options[:group]

          endpoint = @gitlab_url.chomp('/') + '/api/v3'
          token = options[:private_token]
          @connection = ::GitlabClient.new endpoint, token

          log.warn "You have configured a GitLab endpoint to index the #{@group} group."
          log.warn "Using unfinalized artifacts, such as cookbooks retrieved from Git, to satisfiy your"
          log.warn "dependencies is *STRONGLY FROWNED UPON* and potentially *DANGEROUS*."
          log.warn ""
          log.warn "Please consider setting up a release process for the cookbooks you wish to retrieve from this"
          log.warn "GitLab group where the cookbook is uploaded into a Hosted Chef organization, an internal"
          log.warn "Chef Server, or the community site, and then replace this endpoint with a chef_server endpoint."

          super(options)
        end

        # @return [String]
        def to_s
          friendly_name "#{@gitlab_url}/groups/#{group}"
        end

        # @return [Array<RemoteCookbook>]
        #  The list of cookbooks this builder can find
        def cookbooks
          [].tap do |cookbook_versions|
            log.debug "#{self} Searching for cookbooks..."
            connection.group(group).projects.each do |project|
              next unless project.public?

              tags = project.tags.select { |tag| tag =~ /\Av[0-9][0-9.]+\Z/ }
              tags.each do |tag|
                remote_cookbook = find_remote_cookbook(project, tag)
                cookbook_versions << remote_cookbook if remote_cookbook
              end
            end
          end
        rescue ::GitlabClient::Error => ex
          log.warn "#{self} #{ex}"
          []
        end

        # Return the metadata of the given RemoteCookbook. If the metadata could not be found or parsed
        # nil is returned.
        #
        # @param [RemoteCookbook] remote
        #
        # @return [Ridley::Chef::Cookbook::Metadata, nil]
        def metadata(remote)
          load_metadata(remote.external_id, "v#{remote.version}")
        end

        private

        attr_reader :connection

        # Fetches a cookbook for a given project and tag
        #
        # @param [GitlabClient::Project] project
        # @param [String] tag
        # @return [RemoteCookbook]
        def find_remote_cookbook(project, tag)
          begin
            return nil unless cookbook_metadata = load_metadata(project.id, tag)

            if cookbook_metadata.version.to_s == tag[1..-1]
              location_type = 'uri'
              location_path = "#{project.web_url}/repository/archive.tar.gz?ref=#{tag}"
              return RemoteCookbook.new(cookbook_metadata.name,
                                        cookbook_metadata.version,
                                        location_type,
                                        location_path,
                                        priority,
                                        project.id
                                       )
            else
              log.warn "Version found in metadata for #{project.full_path} (#{tag}) does not " +
                "match the tag. Got #{cookbook_metadata.version}."
            end
          rescue ::GitlabClient::Error => ex
            log.warn "#{self} Unable to load group: #{ex}"
          rescue Semverse::InvalidVersionFormat
            log.debug "#{self} Ignoring tag #{tag}. Does not conform to semver."
          end
          nil
        end

        # Helper function for loading metadata from a particular ref in a Gitlab repository
        #
        # @param [String] project_id
        #   name of repository to load from
        # @param [String] ref
        #   reference, tag, or branch to load from
        #
        # @return [Ridley::Chef::Cookbook::Metadata, nil]
        def load_metadata(project_id, ref)
          project = connection.find_project_by_id(project_id)
          content = project.file(Ridley::Chef::Cookbook::Metadata::RAW_FILE_NAME, ref)

          cookbook_metadata = Ridley::Chef::Cookbook::Metadata.new
          cookbook_metadata.instance_eval(content)
          cookbook_metadata
        rescue ::GitlabClient::NoSuchFile => ex
          log.warn("#{self} #{ex}")
          nil
        rescue ::GitlabClient::NoSuchProject => ex
          log.warn("#{self} #{ex}")
          nil
        rescue ::GitlabClient::Error => ex
          log.warn("#{self} Please make sure gitlab is using version 6.6.0 or newer")
          nil
        rescue => ex
          log.warn("#{self} Error getting metadata for project id #{project_id} with ref #{ref}: #{ex}")
          nil
        end
      end
    end
  end
end
