require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::FileStore do
  describe '.worker_type' do
    it 'is file_store' do
      expect(described_class.worker_type).to eq('file_store')
    end
  end

  subject do
    described_class.new(path: fixtures_path.join("cookbooks"))
  end

  it_behaves_like "a human-readable string"

  describe "#cookbooks" do
    it "returns an array containing an item for each valid cookbook on the server" do
      expect(subject.cookbooks.size).to eq(1)
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
