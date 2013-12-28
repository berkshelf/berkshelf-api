require 'spec_helper'

describe Berkshelf::API::Endpoint::V1 do
  include Rack::Test::Methods
  include Berkshelf::API::Mixin::Services

  before { Berkshelf::API::CacheManager.start }
  let(:app) { described_class.new }

  describe "GET /universe" do
    context "the cache has been warmed" do
      before { cache_manager.set_warmed; get '/universe' }

      subject { last_response }
      let(:app_cache) { cache_manager.cache }

      its(:status) { should be(200) }
      its(:body) { should eq(app_cache.to_json) }
    end

    context "the cache is still warming" do
      before { get '/universe' }

      subject { last_response }
      let(:app_cache) { cache_manager.cache }

      its(:status) { should be(503) }
      its(:headers) { should have_key("Retry-After") }
    end
  end

  describe "GET /status" do
    subject { last_response }

    context "the cache has been warmed" do
      before { cache_manager.set_warmed; get '/status'  }
      its(:status) { should be(200) }
      its(:body) { should eq({status: 'ok', version: Berkshelf::API::VERSION, cache_status: 'ok'}.to_json) }
    end

    context "the cache is still warming" do
      before { get '/status' }
      its(:status) { should be(200) }
      its(:body) { should eq({status: 'ok', version: Berkshelf::API::VERSION, cache_status: 'warming'}.to_json) }
    end
  end
end
