require 'json'
require 'faraday'
require 'base64'

# API client for talking to GitLab servers
class GitlabClient
  attr_reader :endpoint, :private_token

  class Error < StandardError; end

  class UnknownFileEncoding < Error; end
  class FourOhFour          < Error; end
  class NoSuchFile          < FourOhFour; end
  class NoSuchGroup         < FourOhFour; end
  class NoSuchProject       < FourOhFour; end

  # @param [String] endpoint
  #   The URL endpoint. e.g. http://gitlab.example.com/api/v3/
  # @param [String] private_token
  #   A user's private access token
  # @param [Logger|NilClass] logger
  #   The a logger for sending event notifications to. Warning, it is
  #   very verbose!
  def initialize(endpoint, private_token, logger = nil)
    @endpoint, @private_token, @logger = endpoint, private_token, logger
  end

  # @param [String] group_path
  #   The API path for the group
  # @return [GitlabClient::Group]
  def group(group_path)
    groups
      .select { |g| g.path == group_path }
      .first
      .tap { |g| fail NoSuchGroup, "No such group: #{group_path}" unless g }
  end

  # @return [Array<GitlabClient::Group>]
  def groups
    get('groups').map { |g| Group.new self, g }
  end

  # @param [Fixnum] project_id
  #   The ID for a project.
  # @return [GitlabClient::Project]
  def find_project_by_id(project_id)
    Project.new self, get("projects/#{project_id}")
  end

  # @return [Array<Hash>] the remote JSON data
  # @api private
  def _projects_for_group_id(group_id)
    get("groups/#{group_id}")['projects']
  rescue FourOhFour
    raise NoSuchGroup, "No such group id: #{group_id}"
  end

  # @return [Array<Hash>] the remote JSON data
  # @api private
  def _tags_for_project_id(project_id)
    get("projects/#{project_id}/repository/tags")
  rescue FourOhFour
    raise NoSuchProject, "No such project id: #{project_id}"
  end

  # @return [Hash] the remote JSON data
  # @api private
  def _file_for_project_id_and_path_and_ref(project_id, filepath, ref)
    get("projects/#{project_id}/repository/files", file_path: filepath, ref: ref)
  rescue FourOhFour
    raise NoSuchFile, "No such file #{filepath} for project id #{project_id} and ref #{ref}"
  end

  # Retreive the remote JSON data.
  #
  # @param [String] url
  #   The relative URL (must not have a leading '/')
  # @param [Hash] query
  #   The GET query. It will be URI encoded properly.
  # @return [Faraday::Response]
  def get(url, query = {})
    fail "Programmer error: remove leading '/' from #{url}" if url.start_with?('/')

    response = connection.get(url, query)
    case response.status
    when 200
      JSON.load response.body
    when 404
      fail FourOhFour, "404 Error: #{url} #{query.inspect}"
    else
      fail Error, "Response failed #{response.inspect}"
    end
  rescue Errno::ETIMEDOUT
    fail Error, "Server timed out: #{url} #{query.inspect}"
  rescue Faraday::ConnectionFailed => err
    fail Error, "Unable to connect to #{url}: #{err}"
  end

  private

  # @return [Faraday]
  def connection
    @connection ||= Faraday.new(url: endpoint) do |faraday|
      faraday.headers[:private_token] = private_token
      faraday.headers[:accept] = 'application/json'
      faraday.response :logger, @logger unless @logger.nil?
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  # GitLab group API
  class Group
    attr_reader :client, :id, :path

    # @param [GitlabClient] client
    #   The client for this project
    # @param [Hash] project_hash
    #   The remote JSON data for a project.
    def initialize(client, group_hash)
      @client, @id, @path = client, group_hash['id'], group_hash['path']
    end

    # @return [Array<GitlabClient::Project>]
    def projects
      client._projects_for_group_id(id).map { |p| Project.new client, p }
    end
  end

  # GitLab project API
  class Project
    attr_reader :client, :id, :path, :full_path, :web_url

    # @param [GitlabClient] client
    #   The client for this project
    # @param [Hash] project_hash
    #   The remote JSON data for a project.
    def initialize(client, project_hash)
      @client, @id, @path, @full_path, @web_url, @public = client,
        project_hash['id'],
        project_hash['path'],
        project_hash['path_with_namespace'],
        project_hash['web_url'],
        project_hash['public']
    end

    # @return [Boolean] Is the repository public?
    def public?
      @public
    end

    # @return [Array<String>]
    def tags
      client._tags_for_project_id(id).map { |h| h['name'] }
    rescue NoSuchProject
      []
    end

    # @param [String] filepath
    #   The path to the file relative to the root of the repository.
    # @return [String] the contents of the file
    def file(filepath, git_ref)
      response = client._file_for_project_id_and_path_and_ref(id, filepath, git_ref)

      case response['encoding']
      when 'base64'
        Base64.decode64(response['content'])
      else
        fail UnknownFileEncoding, "Unable to decode content with encoding #{response['encoding']}"
      end
    end
  end
end
