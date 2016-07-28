require 'spec_helper'

describe Berkshelf::API::Endpoint::V1 do
  include Rack::Test::Methods
  include Berkshelf::API::Mixin::Services

  let(:app) { described_class.new }
  let(:cache_warm) { false }
  let(:rack_env) { Hash.new }

  before do
    Berkshelf::API::CacheManager.start
    cache_manager.set_warmed if cache_warm
  end

  subject { last_response }

  describe "GET /universe" do
    before { get '/universe', {}, rack_env }
    let(:app_cache) { cache_manager.cache }

    context "the cache has been warmed" do
      let(:cache_warm) { true }
      context "the default format is json" do
        subject { last_response }
        let(:app_cache) { cache_manager.cache }

        it 'has the right status' do
          expect(subject.status).to eq(200)
        end

        it 'has the right body' do
          expect(subject.body).to eq(app_cache.to_json)
        end
      end
      context "the user requests json" do
        subject { last_response }
        let(:app_cache) { cache_manager.cache }
        let(:rack_env) { { 'HTTP_ACCEPT' => 'application/json' } }

        it 'has the right status' do
          expect(subject.status).to eq(200)
        end

        it 'has the right body' do
          expect(subject.body).to eq(app_cache.to_json)
        end
      end
      context "the user requests msgpack" do
        subject { last_response }
        let(:app_cache) { cache_manager.cache }
        let(:rack_env) { { 'HTTP_ACCEPT' => 'application/x-msgpack' } }

        it 'has the right status' do
          expect(subject.status).to eq(200)
        end

        it 'has the right body' do
          expect(subject.body).to eq(app_cache.to_msgpack)
        end
      end
    end

    context "the cache is still warming" do
      it 'has the right status' do
        expect(subject.status).to eq(503)
      end

      it 'has the right headers' do
        expect(subject.headers).to have_key('Retry-After')
      end
    end
  end

  describe "GET /status" do
    before do
      allow(Berkshelf::API::Application).to receive(:start_time) { Time.at(0) }
      allow(Time).to receive(:now) { Time.at(100) }
      get '/status'
    end

    context "the cache has been warmed" do
      let(:cache_warm) { true }

      it 'has the right status' do
        expect(subject.status).to eq(200)
      end

      it 'has the right body' do
        status = {
          status:  'ok',
          version: Berkshelf::API::VERSION,
          cache_status: 'ok',
          uptime: 100.0,
        }.to_json

        expect(subject.body).to eq(status)
      end
    end

    context "the cache is still warming" do
      let(:cache_warm) { false }

      it 'has the right status' do
        expect(subject.status).to eq(200)
      end

      it 'has the right body' do
        status = {
          status:  'ok',
          version: Berkshelf::API::VERSION,
          cache_status: 'warming',
          uptime: 100.0,
        }.to_json

        expect(subject.body).to eq(status)
      end
    end
  end
end
