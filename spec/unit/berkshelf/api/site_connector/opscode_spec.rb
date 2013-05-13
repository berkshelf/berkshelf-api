require 'spec_helper'

describe Berkshelf::API::SiteConnector::Opscode do
  let(:connection) { mock("connection") }
  let(:total_response) { stub("total", :body => { "total" => 10 } ) }
  let(:cookbooks_response) do 
    stub("cookbooks", :body => {
      "items"=> [
        {"cookbook_name" => "chicken"}, 
        {"cookbook_name" => "tuna"}
      ]}) 
  end
  let(:chicken_versions_response) do 
    stub("chicken_versions", :body => {
      "versions" => [
        "http://www.example.com/api/v1/cookbooks/chicken/versions/1_0",
        "http://www.example.com/api/v1/cookbooks/chicken/versions/2_0"
      ]}) 
  end

  subject { described_class.new }

  describe "#all_cookbooks" do
    it "should fetch all the cookbooks and return a list of their names" do
      connection.should_receive(:get).
        with("/api/v1/cookbooks?start=0&items=0").
        and_return(total_response)

      connection.should_receive(:get).
        with("/api/v1/cookbooks?start=0&items=10").
        and_return(cookbooks_response)

      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      expect(subject.all_cookbooks).to eql(["chicken", "tuna"])
    end
  end

  describe "#all_versions" do
    it "should call the server for the cookbook provied and return a list of available version number" do
      connection.should_receive(:get).
        with("/api/v1/cookbooks/chicken").
        and_return(chicken_versions_response)

      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      expect(subject.all_versions("chicken")).to eql(["1.0", "2.0"])
    end
  end
end

