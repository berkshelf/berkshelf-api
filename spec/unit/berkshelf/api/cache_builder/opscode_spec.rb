require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Opscode do
  subject { described_class.new }

  its(:archive_name) { should eq("opscode-site") }
end
