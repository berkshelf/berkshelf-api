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
      expect(subject.endpoints).to have(1).item
    end

    it "has the Opscode community site as an endpoint" do
      expect(subject.endpoints.first.type).to eql("opscode")
      expect(subject.endpoints.first.url).to eql("http://cookbooks.opscode.com/api/v1")
    end
  end
end
