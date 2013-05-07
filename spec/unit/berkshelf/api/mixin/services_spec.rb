require 'spec_helper'

describe Berkshelf::API::Mixin::Services do
  let(:includer) do
    Class.new { include Berkshelf::API::Mixin::Services }.new
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
        expect { subject }.to raise_error(Berkshelf::NotStartedError)
      end
    end
  end
end
