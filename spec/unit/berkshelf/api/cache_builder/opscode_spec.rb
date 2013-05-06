require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Opscode do
  subject { described_class.new }

  its(:archive_name) { should eql("opscode-site") }
end
