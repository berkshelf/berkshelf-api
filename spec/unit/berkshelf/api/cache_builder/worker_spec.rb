require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker do
  describe "ClassMethods" do
    describe "::[]" do
      it "returns the class of the registered worker" do
        expect(described_class["opscode"]).to eql(Berkshelf::API::CacheBuilder::Worker::Opscode)
      end
    end

    describe "::register" do
      it "adds the item to the Hash of types" do
        worker = double('new-worker')
        described_class.register("rspec-2", worker)
        expect(described_class.types["rspec-2"]).to eql(worker)
      end
    end

    describe "::types" do
      subject { described_class.types }

      it "returns a Hash" do
        expect(subject).to be_a(Hash)
      end
    end
  end
end

describe Berkshelf::API::CacheBuilder::Worker::Base do
  describe "ClassMethods" do
    describe "::worker_type" do
      let(:klass) { Class.new(described_class) }

      it "registers the worker type and class to Worker.types" do
        klass.worker_type("rspec")
        expect(Berkshelf::API::CacheBuilder::Worker.types).to include("rspec")
      end
    end
  end

  let(:cache_manager) { double(:diff => :chicken) }
  subject { described_class.new(eager_build: false) }

  describe "#diff" do
    it "should delegate to the cache_manager to calculate the diff" do
      subject.should_receive(:cache_manager).and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      expect(subject.diff).to eql(:chicken)
    end

    it "should memoize the diff to prevent recalculating" do
      subject.should_receive(:cache_manager).exactly(1).times.and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      subject.diff
      subject.diff
    end
  end

  describe "#clear_diff" do
    it "should set the diff to nil" do
      subject.should_receive(:cache_manager).and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      subject.diff
      expect(subject.instance_variable_get(:@diff)).to eql(:chicken)
      subject.send(:clear_diff)
      expect(subject.instance_variable_get(:@diff)).to eql(nil)
    end

    it "memoizes the diff to prevent recalculating" do
      subject.should_receive(:cache_manager).exactly(1).times.and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      subject.diff
      subject.diff
    end
  end
end
