require 'spec_helper'

module Berkshelf
  module API
    describe CacheBuilder::Worker::Supermarket do
      describe '.worker_type' do
        it 'is supermarket' do
          expect(described_class.worker_type).to eq('supermarket')
        end
      end

      let(:location_path) { SiteConnector::Supermarket::V1_API }
      let(:location_type) { described_class.worker_type }
      let(:priority)      { 1 }

      let(:universe) do
        {
          'chicken' => {
            '1.0' => {
              'location_type' => 'supermarket',
              'location_path' => location_path,
              'download_url'  => "#{location_path}/cookbooks/chicken/versions/1.0/download",
            },
            '2.0' => {
              'location_type' => 'supermarket',
              'location_path' => location_path,
              'download_url'  => "#{location_path}/cookbooks/chicken/versions/2.0/download",
            }
          },
          'tuna' => {
            '3.0.0' => {
              'location_type' => 'supermarket',
              'location_path' => location_path,
              'download_url'  => "#{location_path}/cookbooks/tuna/versions/3.0.0/download",
            },
            '3.0.1' => {
              'location_type' => 'supermarket',
              'location_path' => location_path,
              'download_url'  => "#{location_path}/cookbooks/tuna/versions/3.0.1/download",
            }
          }
        }
      end

      let(:connection) do
        double(SiteConnector::Supermarket,
          universe: universe,
          api_url:  location_path,
        )
      end

      before do
        subject.instance_variable_set(:@connection, connection)
      end

      subject do
        CacheManager.start
        described_class.new(priority: priority)
      end

      it_behaves_like "a human-readable string"

      describe "#cookbooks" do
        it "returns an array of RemoteCookbooks described by the server" do
          expected = [
            RemoteCookbook.new('chicken', '1.0', location_type, location_path, priority),
            RemoteCookbook.new('chicken', '2.0', location_type, location_path, priority),
            RemoteCookbook.new('tuna', '3.0.0',  location_type, location_path, priority),
            RemoteCookbook.new('tuna', '3.0.1',  location_type, location_path, priority),
          ]

          result = subject.cookbooks
          expect(result).to be_a(Array)

          expect(result[0].name).to eq('chicken')
          expect(result[0].version).to eq('1.0')
          expect(result[0].location_type).to eq(location_type)
          expect(result[0].location_path).to eq(location_path)
          expect(result[0].priority).to eq(priority)

          expect(result[1].name).to eq('chicken')
          expect(result[1].version).to eq('2.0')
          expect(result[1].location_type).to eq(location_type)
          expect(result[1].location_path).to eq(location_path)
          expect(result[1].priority).to eq(priority)

          expect(result[2].name).to eq('tuna')
          expect(result[2].version).to eq('3.0.0')
          expect(result[2].location_type).to eq(location_type)
          expect(result[2].location_path).to eq(location_path)
          expect(result[2].priority).to eq(priority)

          expect(result[3].name).to eq('tuna')
          expect(result[3].version).to eq('3.0.1')
          expect(result[3].location_type).to eq(location_type)
          expect(result[3].location_path).to eq(location_path)
          expect(result[3].priority).to eq(priority)
        end
      end
    end
  end
end
