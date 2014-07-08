require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker do
  describe "ClassMethods" do
    describe "::[]" do
      it "returns the class of the registered worker" do
        expect(described_class["supermarket"]).to eql(Berkshelf::API::CacheBuilder::Worker::Supermarket)
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
end
