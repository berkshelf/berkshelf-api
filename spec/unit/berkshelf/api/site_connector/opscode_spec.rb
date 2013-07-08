require 'spec_helper'

describe Berkshelf::API::SiteConnector::Opscode do
  let(:connection) { double("connection") }
  let(:total_response) { double("total", status: 200, body: { "total" => 10 } ) }
  let(:cookbooks_response) do
    double("cookbooks", status: 200, body: {
      "items"=> [
        {"cookbook_name" => "chicken"},
        {"cookbook_name" => "tuna"}
      ]})
  end
  let(:chicken_versions_response) do
    double("chicken_versions", status: 200, body: {
      "versions" => [
        "http://www.example.com/api/v1/cookbooks/chicken/versions/1_0",
        "http://www.example.com/api/v1/cookbooks/chicken/versions/2_0"
      ]})
  end

  subject { described_class.new }

  describe "#cookbooks" do
    it "should fetch all the cookbooks and return a list of their names" do
      connection.should_receive(:get).
        with("cookbooks").
        and_return(total_response)

      connection.should_receive(:get).
        with("cookbooks?start=0&items=10").
        and_return(cookbooks_response)

      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      expect(subject.cookbooks).to eql(["chicken", "tuna"])
    end
  end

  describe "#versions" do
    it "should call the server for the cookbook provied and return a list of available version number" do
      connection.should_receive(:get).
        with("cookbooks/chicken").
        and_return(chicken_versions_response)

      subject.should_receive(:connection).at_least(1).times.and_return(connection)
      expect(subject.versions("chicken")).to eql(["1.0", "2.0"])
    end
  end

  describe "#find" do
    let(:name) { "nginx" }
    let(:version) { "1.4.0" }
    let(:result) { subject.find(name, version) }

    it "returns the cookbook and version information" do
      expect(result.cookbook).to eq('http://cookbooks.opscode.com/api/v1/cookbooks/nginx')
      expect(result.version).to eq('1.4.0')
    end

    context "when the cookbook is not found" do
      let(:name) { "not_a_real_cookbook_that_anyone_should_ever_make" }

      it "returns nil" do
        expect(result).to be_nil
      end
    end
  end

  describe "#download" do
    let(:name) { "chicken" }
    let(:version) { "1.0.0" }
    let(:destination) { "location" }

    it "should download then ungzip/tar the cookbook" do
      response = { file: "http://file" }
      tempfile = double('tempfile', path: '/some/path', unlink: nil)

      subject.should_receive(:find).with(name, version).and_return(response)
      subject.should_receive(:stream).with("http://file").and_return(tempfile)
      Archive.should_receive(:extract).with(tempfile.path, destination)

      subject.download(name, version, destination)
    end
  end
end

