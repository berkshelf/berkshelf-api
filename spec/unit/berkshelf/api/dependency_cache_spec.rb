require 'spec_helper'

describe Berkshelf::API::DependencyCache do
  describe "ClassMethods" do
    describe "::from_file" do
      let(:filepath) { @tempfile.path }
      before { @tempfile = Tempfile.new('berkshelf-api-rspec') }
      after  { @tempfile.close(true) }

      subject { described_class.from_file(filepath) }

      context "when the file contains valid json" do
        before do
          @tempfile.write(MultiJson.encode(brooke: "winsor"))
          @tempfile.flush
        end

        it "returns an instance of DependencyCache" do
          expect(subject).to be_a(described_class)
        end
      end

      context "when the filepath does not exist" do
        let(:filepath) { nil }

        it "raises a SaveNotFoundError" do
          expect { subject }.to raise_error(Berkshelf::SaveNotFoundError)
        end
      end

      context "when the file does not contain valid JSON" do
        let(:filepath) { @tempfile.path }
        before do
          @tempfile.write("asdfasdfasdf")
          @tempfile.flush
        end

        it "raises an InvalidSaveError" do
          expect { subject }.to raise_error(Berkshelf::InvalidSaveError)
        end
      end
    end
  end
end
