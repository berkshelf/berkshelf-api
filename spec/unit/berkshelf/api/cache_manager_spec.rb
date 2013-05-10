require 'spec_helper'

describe Berkshelf::API::CacheManager do
  describe "ClassMethods" do
    describe "::new" do
      subject { described_class.new }
      its(:cache) { should be_empty }

      context "when a save file exists" do
        before do
          @tempfile = Tempfile.new('berkshelf-api-rspec')
          described_class.any_instance.stub(:save_file) { @tempfile.path }
        end
        after { @tempfile.close(true) }

        it "loads the saved cache" do
          described_class.any_instance.should_receive(:load_save)
          subject
        end
      end

      context "when a save file does not exist" do
        it "skips loading of the saved cache" do
          described_class.any_instance.should_not_receive(:load_save)
          subject
        end
      end
    end
  end

  describe "#add" do
    pending
  end

  describe "#load_save" do
    pending
  end

  describe "#remove" do
    pending
  end
end
