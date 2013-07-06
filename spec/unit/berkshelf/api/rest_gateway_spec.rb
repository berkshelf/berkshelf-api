require 'spec_helper'
require 'berkshelf/api/rest_gateway'

describe Berkshelf::API::RESTGateway do
  describe "ClassMethods" do
    describe "::new" do
      let(:options) { Hash.new }
      subject { described_class.new(options) }

      its(:host) { should eql(described_class::DEFAULT_OPTIONS[:host]) }
      its(:port) { should eql(described_class::DEFAULT_OPTIONS[:port]) }
      its(:workers) { should eql(described_class::DEFAULT_OPTIONS[:workers]) }
      its(:rack_app) { should be_a(Berkshelf::API::RackApp) }

      context "given a different port" do
        before { options[:port] = 26210 }
        its(:port) { should eql(26210) }
      end

      context "given a different amount of workers" do
        before { options[:workers] = 20 }
        its(:workers) { should eql(20) }
      end
    end
  end
end
