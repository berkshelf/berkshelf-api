require 'spec_helper'

describe Berkshelf::API::SiteConnector::Supermarket do
  let(:url) { 'https://example.com' }
  let(:json) do
    <<-EOH.gsub(/^ {6}/, '')
      {
        "berkshelf": {
          "0.1.0": {
            "location_type": "supermarket",
            "location_path": "#{url}",
            "download_url": "#{url}/cookbooks/berkshelf/versions/0.1.0/download",
            "dependencies": {
              "ruby": ">= 0.0.0"
            }
          },
          "0.2.0": {
            "location_type": "supermarket",
            "location_path": "#{url}",
            "download_url": "#{url}/cookbooks/berkshelf/versions/0.2.0/download",
            "dependencies": {
              "ruby": ">= 0.0.0"
            }
          }
        }
      }
    EOH
  end

  subject { described_class.new(url: url) }

  before do
    allow(subject).to receive(:open)
      .and_return(double(File, read: json))
  end

  describe "#universe" do
    it "uses OpenURI to get the universe" do
      expect(subject).to receive(:open)
        .with("#{url}/universe.json", kind_of(Hash))

      subject.universe
    end

    it 'parses the response as JSON' do
      expect(subject.universe).to be_a(Hash)
      expect(subject.universe).to have_key('berkshelf')
    end

    context 'when the server does not respond' do
      before do
        allow(subject).to receive(:open)
          .and_raise(Timeout::Error)
      end

      it 'catches and logs the error' do
        expect(subject.log).to receive(:error).with(/in 15 seconds/)
        expect { subject.universe }.to_not raise_error
      end
    end

    context 'when the response is not valid JSON' do
      let(:json) { 'bad json' }

      it 'catches a JSON::ParserError' do
        expect(subject.log).to receive(:error).with(/^Failed to parse JSON/)
        expect { subject.universe }.to_not raise_error
      end
    end

    [
      SocketError,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::ENETUNREACH,
    ].each do |error|
      context "when `#{error}' is raised" do
        before do
          allow(subject).to receive(:open)
            .and_raise(error)
        end

        it "catches and logs the error" do
          expect(subject.log).to receive(:error).with(/^Failed to get/)
          expect { subject.universe }.to_not raise_error
        end
      end
    end
  end
end
