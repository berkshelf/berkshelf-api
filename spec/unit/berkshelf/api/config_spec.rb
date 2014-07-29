require 'spec_helper'

describe Berkshelf::API::Config do
  describe "ClassMethods" do
    describe "::default_path" do
      it "returns a String" do
        expect(described_class.default_path).to be_a(String)
      end
    end
  end

  describe "default config" do
    subject { described_class.new }

    it "has a endpoint configured" do
      expect(subject.endpoints.size).to eq(1)
    end

    it "has the Supermarket community site as an endpoint" do
      expect(subject.endpoints.first.type).to eql("supermarket")
    end

    it "has the default build_interval" do
      expect(subject.build_interval).to eq(5.0)
    end
  end
end