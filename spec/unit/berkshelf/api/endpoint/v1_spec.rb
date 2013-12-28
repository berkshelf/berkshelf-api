require 'spec_helper'

describe Berkshelf::API::Endpoint::V1 do
  include Rack::Test::Methods
  include Berkshelf::API::Mixin::Services

  let(:app) { described_class.new }
  let(:cache_warm) { false }

  before do
    Berkshelf::API::CacheManager.start
    cache_manager.set_warmed if cache_warm
  end

  subject { last_response }

  describe "GET /universe" do
    before { get '/universe' }
    let(:app_cache) { cache_manager.cache }

    context "the cache has been warmed" do
      let(:cache_warm) { true }

      its(:status) { should be(200) }
      its(:body) { should eq(app_cache.to_json) }
    end

    context "the cache is still warming" do
      its(:status) { should be(503) }
      its(:headers) { should have_key("Retry-After") }
    end
  end

  describe "GET /status" do
    before do
      Berkshelf::API::Application.stub(:start_time) { Time.at(0) }
      Time.stub(:now) { Time.at(100) }
      get '/status'
    end

    context "the cache has been warmed" do
      let(:cache_warm) { true }

      its(:status) { should be(200) }
      its(:body) { should eq({status: 'ok', version: Berkshelf::API::VERSION, cache_status: 'ok', uptime: 100.0}.to_json) }
    end

    context "the cache is still warming" do
      its(:status) { should be(200) }
      its(:body) { should eq({status: 'ok', version: Berkshelf::API::VERSION, cache_status: 'warming', uptime: 100.0}.to_json) }
    end
  end
end
