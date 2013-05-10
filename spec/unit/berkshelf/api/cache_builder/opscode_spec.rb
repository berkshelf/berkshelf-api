require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Opscode do
  subject do
    Berkshelf::API::CacheManager.start 
    described_class.new
  end

  its(:archive_name) { should eq("opscode-site") }

  describe "#cookbooks" do
    pending
  end
end
