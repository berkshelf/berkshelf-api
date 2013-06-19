require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::ChefServer do
  describe "ClassMethods" do
    subject { described_class }
    its(:worker_type) { should eql("chef_server") }
  end
end
