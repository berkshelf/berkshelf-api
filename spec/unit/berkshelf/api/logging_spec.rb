require 'spec_helper'

describe Berkshelf::API::Logging do
  describe "ClassMethods" do
    subject { described_class }

    describe "::init" do
      after { described_class.init(location: nil) }

      it "sets the Celluloid.logger to ::logger" do
        subject.init
        expect(Celluloid.logger).to eql(subject.logger)
      end
    end

    describe "::logger" do
      it "returns a Logger object" do
        expect(subject.logger).to be_a(Logger)
      end
    end
  end

  describe "#logger" do
    it "returns a Logger object" do
      expect(subject.logger).to be_a(Logger)
    end
  end
end
