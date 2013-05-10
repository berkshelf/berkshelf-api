require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Opscode do
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
    described_class.new(:connection => connection)
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

      Berkshelf::API::CacheManager.start 
      builder = described_class.new(:connection => connection)
      expect(builder.cookbooks).to eql(expected_value)
    end

    it "respects options[:get_only] to limit the number of cookbooks requested" do
      expected_value = [
        Berkshelf::API::RemoteCookbook.new("chicken", "1.0"),
        Berkshelf::API::RemoteCookbook.new("chicken", "2.0"),
      ]

      Berkshelf::API::CacheManager.start 
      builder = described_class.new({
        :get_only => 1,
        :connection => connection
      })
      expect(builder.cookbooks).to eql(expected_value)
    end
  end
end
