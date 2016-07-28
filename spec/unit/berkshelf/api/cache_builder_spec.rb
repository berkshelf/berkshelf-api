require 'spec_helper'

describe Berkshelf::API::CacheBuilder do

  before { Berkshelf::API::CacheManager.start }
  let(:instance) { described_class.new }

  describe "#build" do
    subject(:build) { instance.build }
    let(:workers) { [ double('worker') ] }
    let(:future) { double('future', value: nil) }
    let(:cache_manager) { double('cache_manager') }

    before do
      # https://github.com/celluloid/celluloid/wiki/Testing
      allow(instance.wrapped_object).to receive(:workers).and_return(workers)
      allow(instance.wrapped_object).to receive(:cache_manager).and_return(cache_manager)
      allow(cache_manager).to receive(:process_workers)
    end

    it "asks the cache_manager to process all of its actors" do
      expect(cache_manager).to receive(:process_workers).with(workers)
      instance.build
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

    context "when no workers are explicitly configured" do
      it "has one worker started by default" do
        expect(workers.size).to eq(1)
      end

      it "has an Supermarket worker started by default" do
        expect(workers.first).to be_a(described_class::Worker::Supermarket)
      end
    end

    context "when there are multiple workers" do
      let(:endpoint_array) { [ first_worker, second_worker ] }
      let(:first_worker) { double(options: endpoint_options.dup.merge(priority: 0), type: 'chicken') }
      let(:second_worker) { double(options: endpoint_options.dup.merge(priority: 1), type: 'tuna') }
      let(:endpoint_options) do
        {
          "url" => "www.fake.com",
          "client_name" => "fake",
          "client_key" => "/path/to/fake.key"
        }
      end
      let(:dummy_endpoint_klass) do
        Class.new do
          attr_reader :options
          include Celluloid

          def initialize(options = {})
            @options = options
          end
        end
      end

      before do
        allow(Berkshelf::API::Application.config).to receive(:endpoints).and_return(endpoint_array)
        allow(Berkshelf::API::CacheBuilder::Worker).to receive(:[]).and_return(dummy_endpoint_klass, dummy_endpoint_klass)
      end

      it "has two workers" do
        expect(workers.size).to eq(2)
      end

      it "keeps the ordering" do
        expect(workers.first.options[:priority]).to be(0)
        expect(workers.last.options[:priority]).to be(1)
      end
    end
  end
end
