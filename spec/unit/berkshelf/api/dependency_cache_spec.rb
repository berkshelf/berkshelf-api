require 'spec_helper'

def remote_cookbook(name, version, location_type = 'supermarket', location_path = 'https://supermarket.getchef.com', priority = 1, info = {})
  Berkshelf::API::RemoteCookbook.new(name, version, location_type, location_path, priority, info)
end

describe Berkshelf::API::DependencyCache do
  describe "ClassMethods" do
    describe "::from_file" do
      let(:filepath) { @tempfile.path }
      before { @tempfile = Tempfile.new('berkshelf-api-rspec') }
      after  { @tempfile.close(true) }

      subject { described_class.from_file(filepath) }

      context "when the file contains valid json" do
        before do
          @tempfile.write(JSON.generate({brooke: "winsor"}))
          @tempfile.flush
        end

        it "returns an instance of DependencyCache" do
          expect(subject).to be_a(described_class)
        end
      end

      context "when the filepath does not exist" do
        let(:filepath) { nil }

        it "raises a SaveNotFoundError" do
          expect { subject }.to raise_error(Berkshelf::API::SaveNotFoundError)
        end
      end

      context "when the file does not contain valid JSON" do
        let(:filepath) { @tempfile.path }
        before do
          @tempfile.write("asdfasdfasdf")
          @tempfile.flush
        end

        it "raises an InvalidSaveError" do
          expect { subject }.to raise_error(Berkshelf::API::InvalidSaveError)
        end
      end
    end
  end

  let(:chicken) do
    { "1.0" =>
      {
        dependencies: { "tuna" => "= 3.0.0" },
        platforms: { "centos" => ">= 0.0.0" }
      }
    }
  end
  let(:tuna) do
    { "3.0.0" =>
      {
        dependencies: { },
        platforms: { "centos" => ">= 0.0.0" }
      }
    }
  end
  let(:contents) do
    {
      "chicken" => chicken,
      "tuna" => tuna,
    }
  end

  subject { described_class.new(contents) }

  context "when a new DependencyCache is created" do
    it "should allow indifferent access to items in the cache" do
      expect(subject[:chicken]).to be_a(Hash)
      expect(subject[:chicken][:'1.0'][:dependencies]).to be_a(Hash)
    end
  end

  describe "#cookbooks" do
    it "should return a list of RemoteCookbooks" do
      expected_value = [
        remote_cookbook("chicken", "1.0"),
        remote_cookbook("tuna", "3.0.0")
      ]

      expect(subject.cookbooks).to eql(expected_value)
    end
  end

  describe "#add" do
    let(:cookbook) { remote_cookbook("ruby", "1.2.3", "supermarket") }
    before { subject.clear }

    it "adds items to the cache" do
      subject.add(cookbook, double(platforms: nil, dependencies: nil))
      expect(subject.to_hash.size).to eq(1)
    end
  end

  describe "#save" do
    let(:path) { tmp_path.join('cerch.json') }

    it "saves the contents of the cache as json to the given path" do
      subject.save(path)
      expect(File.exist?(path)).to be_truthy
    end
  end

  describe "#clear" do
    let(:cookbook) { remote_cookbook("ruby", "1.2.3", "supermarket") }
    before { subject.add(cookbook, double(platforms: nil, dependencies: nil)) }

    it "empties items added to the cache" do
      subject.clear
      expect(subject).to be_empty
    end
  end
end
