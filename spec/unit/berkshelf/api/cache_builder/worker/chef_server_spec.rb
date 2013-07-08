require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::ChefServer do
  describe "ClassMethods" do
    subject { described_class }
    its(:worker_type) { should eql("chef_server") }
  end

  subject do
    described_class.new(url: "http://localhost:8889", client_name: "reset",
      client_key: fixtures_path.join("reset.pem"))
  end

  describe "#cookbooks" do
    before do
      chef_cookbook("ruby", "1.0.0")
      chef_cookbook("ruby", "2.0.0")
      chef_cookbook("elixir", "3.0.0")
      chef_cookbook("elixir", "3.0.1")
    end

    it "returns an array containing an item for each cookbook on the server" do
      expect(subject.cookbooks).to have(4).items
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

  describe "#build" do
    before do
      Berkshelf::API::CacheManager.start
      chef_cookbook("ruby", "1.0.0")
      chef_cookbook("ruby", "2.0.0")
      chef_cookbook("elixir", "3.0.0")
      chef_cookbook("elixir", "3.0.1")
    end

    let(:cache) { Berkshelf::API::CacheManager.instance.cache }

    it "adds each item to the cache" do
      subject.build
      expect(cache).to have_cookbook("ruby", "1.0.0")
      expect(cache).to have_cookbook("ruby", "2.0.0")
      expect(cache).to have_cookbook("elixir", "3.0.0")
      expect(cache).to have_cookbook("elixir", "3.0.1")
      expect(cache.cookbooks).to have(4).items
    end
  end
end
