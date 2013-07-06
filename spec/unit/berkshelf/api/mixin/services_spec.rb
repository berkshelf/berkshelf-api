require 'spec_helper'
require 'berkshelf/api/rest_gateway'

describe Berkshelf::API::Mixin::Services do
  let(:includer) do
    Class.new { include Berkshelf::API::Mixin::Services }.new
  end

  describe "#cache_builder" do
    subject { includer.cache_builder }

    context "when the CacheBuilder is running" do
      before { Berkshelf::API::CacheBuilder.start }

      it "returns the running instance of CacheBuilder" do
        expect(subject).to be_a(Berkshelf::API::CacheBuilder)
      end
    end

    context "when the CacheBuilder is not running" do
      before { Berkshelf::API::CacheBuilder.stop }

      it "raises a NotStartedError" do
        expect { subject }.to raise_error(Berkshelf::API::NotStartedError)
      end
    end
  end

  describe "#cache_manager" do
    subject { includer.cache_manager }

    context "when the CacheManager is running" do
      before { Berkshelf::API::CacheManager.start }

      it "returns the running instance of CacheManager" do
        expect(subject).to be_a(Berkshelf::API::CacheManager)
      end
    end

    context "when the CacheManager is not running" do
      before { Berkshelf::API::CacheManager.stop }

      it "raises a NotStartedError" do
        expect { subject }.to raise_error(Berkshelf::API::NotStartedError)
      end
    end
  end

  describe "#rest_gateway" do
    subject { includer.rest_gateway }

    context "when the RESTGateway is running" do
      before { Berkshelf::API::RESTGateway.start }

      it "returns the running instance of RESTGateway" do
        expect(subject).to be_a(Berkshelf::API::RESTGateway)
      end
    end

    context "when the RESTGateway is not running" do
      before { Berkshelf::API::RESTGateway.stop }

      it "raises a NotStartedError" do
        expect { subject }.to raise_error(Berkshelf::API::NotStartedError)
      end
    end
  end
end
