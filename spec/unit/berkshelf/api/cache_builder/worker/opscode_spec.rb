require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::Opscode do
  describe "ClassMethods" do
    subject { described_class }
    its(:worker_type) { should eql("opscode") }
  end

  let(:cookbooks) { ["chicken", "tuna"] }
  let(:chicken_versions) { ["1.0", "2.0"] }
  let(:tuna_versions) { ["3.0.0", "3.0.1"] }
  let(:connection) do
    connection = double('connection')
    connection.stub(:cookbooks).and_return(cookbooks)
    connection
  end

  subject do
    Berkshelf::API::CacheManager.start
    described_class.new
  end

  describe "#cookbooks" do
    it "returns an array of RemoteCookbooks described by the server" do
      expected_value = [
        Berkshelf::API::RemoteCookbook.new("chicken", "1.0", described_class.worker_type),
        Berkshelf::API::RemoteCookbook.new("chicken", "2.0", described_class.worker_type),
        Berkshelf::API::RemoteCookbook.new("tuna", "3.0.0", described_class.worker_type),
        Berkshelf::API::RemoteCookbook.new("tuna", "3.0.1", described_class.worker_type)
      ]

      connection.should_receive(:future).with(:versions, "chicken").and_return(double(value: chicken_versions))
      connection.should_receive(:future).with(:versions, "tuna").and_return(double(value: tuna_versions))
      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      expect(subject.cookbooks).to eql(expected_value)
    end
  end
end
