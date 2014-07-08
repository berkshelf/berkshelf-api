require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::Gitlab do
  describe "ClassMethods" do
    subject { described_class }
    its(:worker_type) { should eql("gitlab") }
  end

  subject(:worker) do
    expect(GitlabClient)
      .to receive(:new) { connection }
    described_class.new(group: group, url: url, private_token: token)
  end

  let(:connection) { double GitlabClient }
  let(:group) { "group#{rand 99}" }
  let(:url)   { "http://gitlab#{rand 9}.example.com/" }
  let(:token) { "token#{rand 99}" }

  it_behaves_like "a human-readable string"

  describe "#cookbooks" do
    let(:group_double)   { double GitlabClient::Group }
    let(:project_double) { double GitlabClient::Project, id: project_id }
    let(:project_id)     { rand 99 }
    let(:good_tag)       { 'v1.2.3' }

    # Connection
    before do
      expect(connection)
        .to receive(:group)
        .with(group)
        .and_return(group_double)
      expect(connection)
        .to receive(:find_project_by_id)
        .with(project_id)
        .and_return(project_double)
    end

    # Group
    before do
      expect(group_double)
        .to receive(:projects)
        .and_return([project_double])
    end

    # Project
    before do
      expect(project_double)
        .to receive(:public?)
        .and_return(true)
      expect(project_double)
        .to receive(:tags)
        .and_return([good_tag, 'bad-tag'])
      allow(project_double)
        .to receive(:full_path)
        .and_return("full/path")
      expect(project_double)
        .to receive(:web_url)
        .and_return('http:/example.com')
      expect(project_double)
        .to receive(:file)
        .with('metadata.rb', good_tag)
        .and_return("name 'some-cookbook'\nversion '#{good_tag[1..-1]}'")
    end

    it 'returns an array containing an item for each valid cookbook on the server' do
      expect(subject.cookbooks).to have(1).items
    end

    it 'returns an array of RemoteCookbooks' do
      subject.cookbooks.each do |cookbook|
        expect(cookbook).to be_a(Berkshelf::API::RemoteCookbook)
      end
    end

    it 'each RemoteCookbook is tagged with a location_type of :uri' do
      subject.cookbooks.each do |cookbook|
        expect(cookbook.location_type).to eql('uri')
      end
    end
  end
end
