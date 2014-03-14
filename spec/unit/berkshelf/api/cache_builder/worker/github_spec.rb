require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::Github do
  describe "ClassMethods" do
    subject { described_class }
    its(:worker_type) { should eql("github") }
  end

  let(:connection) do
    double('connection')
  end

  let(:good_tag) do
    tag = double('good_tag')
    tag.stub(:name) { 'v1.0.0' }
    tag
  end

  let(:bad_tag) do
    tag = double('good_tag')
    tag.stub(:name) { 'beta2' }
    tag
  end

  let :contents do
    contents = double('contents')
    contents.stub(:content) { 'dmVyc2lvbiAiMS4wLjAi' }
    contents
  end

  let(:repo) do
    repo = double('repo')
    repo.stub(:full_name) { 'opscode-cookbooks/apt' }
    repo.stub(:name) { 'apt' }
    repo
  end

  let(:repos) do
    [repo]
  end

  subject do
    expect(Octokit::Client).to receive(:new) { connection }
    described_class.new(organization: "opscode-cookbooks", access_token: "asdf")
  end

  describe "#cookbooks" do
    before do
      expect(connection).to receive(:organization_repositories) { repos }
      expect(connection).to receive(:tags) { [good_tag, bad_tag] }
      expect(connection).to receive(:contents).with("opscode-cookbooks/apt",
        { path: "metadata.rb", ref: "v1.0.0"}) { contents }
    end

    it "returns an array containing an item for each valid cookbook on the server" do
      expect(subject.cookbooks).to have(1).items
    end

    it "returns an array of RemoteCookbooks" do
      subject.cookbooks.each do |cookbook|
        expect(cookbook).to be_a(Berkshelf::API::RemoteCookbook)
      end
    end

    it "each RemoteCookbook is tagged with a location_type matching the worker_type of the builder" do
      subject.cookbooks.each do |cookbook|
        expect(cookbook.location_type).to eql(described_class.worker_type)
      end
    end
  end
end
