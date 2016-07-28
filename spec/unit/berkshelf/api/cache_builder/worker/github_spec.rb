require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::Github do
  describe '.worker_type' do
    it 'is github' do
      expect(described_class.worker_type).to eq('github')
    end
  end

  let(:connection) do
    double('connection')
  end

  let(:good_tag) do
    double('good_tag', name: 'v1.0.0')
  end

  let(:bad_tag) do
    double('good_tag', name: 'beta2')
  end

  let :contents do
    double('contents', content: 'dmVyc2lvbiAiMS4wLjAi')
  end

  let(:repo) do
    double('repo',
      name: 'apt',
      full_name: 'opscode-cookbooks/apt',
      html_url: 'https://github.com/opscode-cookbooks/apt',
    )
  end

  let(:repo_mismached) do
    double('repo',
      name: 'enterprise',
      full_name: 'opscode-cookbooks/enterprise-chef-common',
      html_url: 'https://github.com/opscode-cookbooks/enterprise-chef-common',
    )
  end

  let(:repos) do
    [repo, repo_mismached]
  end

  subject do
    expect(Octokit::Client).to receive(:new).and_return(connection)
    described_class.new(organization: "opscode-cookbooks", access_token: "asdf")
  end

  it_behaves_like "a human-readable string"

  describe "#cookbooks" do

    before do
      expect(connection).to receive(:organization_repositories) { repos }
      repos.each do |repo|
        expect(connection).to receive(:tags) { [good_tag, bad_tag] }
        expect(connection).to receive(:contents).with("opscode-cookbooks/" + repo.name,
          { path: "metadata.rb", ref: "v1.0.0"}) { contents }
      end
    end

    it "returns an array containing an item for each valid cookbook on the server" do
      expect(subject.cookbooks.size).to eq(2)
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
