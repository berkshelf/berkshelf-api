require 'spec_helper'
require 'gitlab_client'

describe GitlabClient do
  subject(:client) { described_class.new(endpoint, private_token) }

  let(:endpoint)      { "http://127.0.0.1:9999/gitlab#{rand 99}" }
  let(:private_token) { "private-token-#{rand 9999}" }

  describe '::new' do
    its(:endpoint) { should eq(endpoint) }

    its(:private_token) { should eq(private_token) }
  end

  context 'with a stubbed network' do
    before do
      allow(client)
        .to receive(:connection)
        .and_return(double(Faraday))
    end

    describe '.group' do
      let(:group_path) { 'chef-cookbooks' }

      before do
        expect(client)
          .to receive(:groups)
          .and_return([double(GitlabClient::Group, path: group_path)])
      end

      it 'returns the group' do
        expect(client.group(group_path).path)
          .to eq(group_path)
      end

      it 'raises NoSuchGroup if missing' do
        expect { client.group('no-such-group') }
          .to raise_error(GitlabClient::NoSuchGroup)
      end
    end

    describe '.groups' do
      let(:group_hashes) { [double('group hash')] }

      before do
        expect(client)
          .to receive(:get)
          .with('groups')
          .and_return(group_hashes)

        allow(GitlabClient::Group)
          .to receive(:new)
      end

      it 'calls Group.new for each response' do
        group_hashes.each do |group_hash|
          expect(GitlabClient::Group)
            .to receive(:new)
            .with(client, group_hash)
        end

        client.groups
      end
    end

    describe '.find_project_by_id' do
      let(:project_id) { rand 99 }
      let(:response) { double 'get(projects/:id)' }

      before do
        expect(client)
          .to receive(:get)
          .with("projects/#{project_id}")
          .and_return(response)

        allow(GitlabClient::Project)
          .to receive(:new)
      end

      it 'creates a Project' do
        project = double
        expect(GitlabClient::Project)
          .to receive(:new)
          .with(client, response)
          .and_return(project)

        expect(client.find_project_by_id project_id)
          .to eq(project)
      end
    end

    describe '._projects_for_group_id' do
      context 'the group is invalid' do
        before { allow(client).to receive(:get).and_raise(GitlabClient::FourOhFour) }

        it 'raises NoSuchGroup' do
          expect { client._projects_for_group_id 2 }
            .to raise_error(GitlabClient::NoSuchGroup)
        end
      end
    end

    describe '._tags_for_project_id' do
      context 'the project is invalid' do
        before { allow(client).to receive(:get).and_raise(GitlabClient::FourOhFour) }

        it 'raises NoSuchProject' do
          expect { client._tags_for_project_id 2 }
            .to raise_error(GitlabClient::NoSuchProject)
        end
      end
    end

    describe '._file_for_project_id_and_path_and_ref' do
      context 'the project is invalid' do
        before { allow(client).to receive(:get).and_raise(GitlabClient::FourOhFour) }

        it 'raises NoSuchProject' do
          expect { client._file_for_project_id_and_path_and_ref 2, '.rspec', 'master' }
            .to raise_error(GitlabClient::NoSuchFile)
        end
      end
    end
  end
end

describe GitlabClient::Group do
  subject(:group) { described_class.new(client, 'id' => id, 'path' => path) }

  let(:client) { double GitlabClient, _projects_for_group_id: project_hashes }
  let(:id) { rand 99 }
  let(:path) { "group#{id}" }

  its(:client)    { should eq(client) }
  its(:id)        { should eq(id) }
  its(:path)      { should eq(path) }

  let(:project_hashes) do
    (1..3).map do |i|
      {
        'id' => i,
        'path' => "path#{i}",
        'path_with_namespace' => "#{path}/path#{i}"
      }
    end
  end

  describe '.projects' do
    it 'calls client._projects_for_group_id' do
      expect(client)
        .to receive(:_projects_for_group_id)
        .with(id)

      group.projects
    end

    it 'calls Project.new' do
      project_hashes.each do |hash|
        expect(GitlabClient::Project)
          .to receive(:new)
          .with(client, hash)
      end

      group.projects
    end
  end
end

describe GitlabClient::Project do
  subject(:project) do
    described_class.new(client,
                        'id' => id,
                        'path' => path,
                        'path_with_namespace' => full_path,
                        'web_url' => web_url,
                        'public' => is_public)
  end

  let(:client)    { double GitlabClient, _tags_for_project_id: tag_hashes }
  let(:id)        { rand 99 }
  let(:path)      { "project#{id}" }
  let(:full_path) { "group/#{path}" }
  let(:web_url)   { "http://gitlab.example.com/#{full_path}" }
  let(:is_public)    { rand(2) == 1 }

  let(:tag_hashes) do
    (1..2).map do |i|
      { 'name' => "name#{i}" }
    end
  end

  its(:client)    { should eq(client) }
  its(:id)        { should eq(id) }
  its(:path)      { should eq(path) }
  its(:full_path) { should eq(full_path) }
  its(:web_url)   { should eq(web_url) }
  its(:public?)   { should eq(is_public) }

  describe '.tags' do
    it 'calls client._tags_for_project_id' do
      expect(client)
        .to receive(:_tags_for_project_id)
        .with(id)
        .and_return(tag_hashes)

      project.tags
    end

    it 'gets the name of each tag' do
      tag_hashes.each do |tag_hash|
        expect(tag_hash)
          .to receive(:[])
          .with('name')
      end

      project.tags
    end

    its(:tags) { should match_array(tag_hashes.map{|th| th['name']}) }
  end

  describe '.file' do
    let(:ref) { "v#{rand 99}" }
    let(:filename) { "lib/file{#rand 99}.rb" }
    let(:file_response) do
      {
        'encoding' => 'base64',
        'content' => "QmUgc3VyZSB0byBkcmluayB5b3VyIE92YWx0aW5l\n"
      }
    end

    before do
      expect(client)
        .to receive(:_file_for_project_id_and_path_and_ref)
        .with(id, filename, ref)
        .and_return(file_response)
    end

    it 'decodes the response' do
      expect(project.file(filename, ref))
        .to eq('Be sure to drink your Ovaltine')
    end

    context 'with an unknown encoding' do
      let(:file_response) do
        { 'encoding' => 'fubar' }
      end

      it 'raises an UnknownFileEncoding error' do
        expect { project.file(filename, ref) }
          .to raise_error(GitlabClient::UnknownFileEncoding)
      end
    end
  end
end
