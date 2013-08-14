require 'spec_helper'

describe Berkshelf::API::CacheBuilder do

  before { Berkshelf::API::CacheManager.start }
  let(:instance) { described_class.new }

  describe "#build" do
    subject(:build) { instance.build }
    let(:workers) { [ double('worker') ] }
    let(:future) { double('future', value: nil) }

    before { instance.stub(workers: workers) }

    it "sends a #build message to each worker" do
      workers.each { |worker| worker.should_receive(:future).with(:build).and_return(future) }
      build
    end
  end

  describe "#workers" do
    subject(:workers) { instance.workers }

    it "returns an array of workers" do
      expect(workers).to be_a(Array)
      workers.each do |worker|
        expect(worker).to be_a(described_class::Worker::Base)
      end
    end

    it "has one worker started by default" do
      expect(workers).to have(1).item
    end

    it "has an opscode worker started by default" do
      expect(workers.first).to be_a(described_class::Worker::Opscode)
    end
  end
end
