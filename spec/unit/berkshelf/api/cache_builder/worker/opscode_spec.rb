require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::Opscode do
  let(:cookbooks) { ["chicken", "tuna"] }
  let(:chicken_versions) { ["1.0", "2.0"] }
  let(:tuna_versions) { ["3.0.0", "3.0.1"] }
  let(:connection) do
    connection = Object.new
    connection.stub(:all_cookbooks).and_return(cookbooks)
    connection.stub(:all_versions).with("chicken").and_return(chicken_versions)
    connection.stub(:all_versions).with("tuna").and_return(tuna_versions)
    connection
  end
  subject do
    Berkshelf::API::CacheManager.start
    described_class.new()
  end

  its(:archive_name) { should eq("opscode-site") }

  describe "#cookbooks" do
    it "returns an array of RemoteCookbooks described by the server" do
      expected_value = [
        Berkshelf::API::RemoteCookbook.new("chicken", "1.0"),
        Berkshelf::API::RemoteCookbook.new("chicken", "2.0"),
        Berkshelf::API::RemoteCookbook.new("tuna", "3.0.0"),
        Berkshelf::API::RemoteCookbook.new("tuna", "3.0.1"),
      ]

      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      expect(subject.cookbooks).to eql(expected_value)
    end

    it "respects options[:get_only] to limit the number of cookbooks requested" do
      expected_value = [
        Berkshelf::API::RemoteCookbook.new("chicken", "1.0"),
        Berkshelf::API::RemoteCookbook.new("chicken", "2.0"),
      ]

      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      subject.should_receive(:options).and_return({:get_only => 1})
      expect(subject.cookbooks).to eql(expected_value)
    end
  end
end
