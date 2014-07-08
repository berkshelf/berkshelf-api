require 'spec_helper'
require 'berkshelf/api/rest_gateway'

module Berkshelf
  module API
    describe RESTGateway do
      let(:options) { {} }
      subject { described_class.new(options) }

      describe '.new' do
        context 'when given a different port' do
          before do
            options[:port] = 26210
          end

          it 'uses the correct port' do
            expect(subject.port).to eq(26210)
          end
        end
      end

      describe '#host' do
        it 'has the default value' do
          expect(subject.host).to eq(described_class::DEFAULT_OPTIONS[:host])
        end
      end

      describe '#port' do
        it 'has the default value' do
          expect(subject.port).to eq(described_class::DEFAULT_OPTIONS[:port])
        end
      end

      describe '#app' do
        it 'has the default value' do
          expect(subject.app).to be_a(RackApp)
        end
      end
    end
  end
end
