require 'spec_helper'

describe Berkshelf::API::Endpoint::V1 do
  include Rack::Test::Methods
  include Berkshelf::API::Mixin::Services

  before { Berkshelf::API::CacheManager.start }
  let(:app) { described_class.new }

  describe "GET /universe" do
    before  { get '/universe' }
    subject { last_response }
    let(:app_cache) { cache_manager.cache }

    its(:status) { should be(200) }
    its(:body) { should eq(app_cache.to_json) }
  end
end
