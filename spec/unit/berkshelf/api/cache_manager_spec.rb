require 'spec_helper'

describe Berkshelf::API::CacheManager do
  describe "ClassMethods" do
    describe "::new" do
      subject { described_class.new }
      its(:cache) { should be_empty }
    end
  end

  describe "#add" do
    pending
  end

  describe "#remove" do
    pending
  end
end
