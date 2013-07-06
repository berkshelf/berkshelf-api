require 'spec_helper'

describe Berkshelf::API::Application do
  describe "ClassMethods" do
    subject { described_class }

    its(:registry) { should be_a(Celluloid::Registry) }

    describe "::run!" do
      include Berkshelf::API::Mixin::Services

      let(:options) { { log_location: '/dev/null' } }
      subject(:run) { described_class.run!(options) }

      context "when given true for :disable_http" do
        it "does not start the REST Gateway" do
          options[:disable_http] = true
          run
          expect(rest_gateway).to be_nil
        end
      end
    end
  end
end
