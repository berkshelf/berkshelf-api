require 'spec_helper'

describe Berkshelf::API::Application do
  describe "ClassMethods" do
    describe '.registry' do
      it 'returns a Celluloid::Registry' do
        expect(described_class.registry).to be_a(Celluloid::Registry)
      end
    end

    describe "::configure" do
      let(:options) { Hash.new }
      subject(:configure) { described_class.configure(options) }
      before { @original = described_class.config }
      after  { described_class.set_config(@original) }

      context "given a value for :config_file" do
        let(:filepath) { tmp_path.join('rspec-config.json') }
        before { options[:config_file] = filepath }

        it "sets the configuration from the contents of the file" do
          generated = Berkshelf::API::Config.new(filepath)
          generated.endpoints = [ { what: "this" } ]
          generated.save
          configure

          expect(described_class.config.endpoints).to have(1).item
        end

        context "if the file cannot be found or loaded" do
          it "raises a ConfigNotFoundError" do
            expect { configure }.to raise_error(Berkshelf::API::ConfigNotFoundError)
          end
        end
      end
    end

    describe "::run!" do
      include Berkshelf::API::Mixin::Services

      let(:options) { { log_location: '/dev/null' } }
      subject(:run) { described_class.run!(options) }

      context "when given true for :disable_http" do
        it "does not start the REST Gateway" do
          options[:disable_http] = true
          run
          expect { rest_gateway }.to raise_error(Berkshelf::API::NotStartedError)
        end
      end
    end
  end
end
