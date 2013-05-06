require 'spec_helper'

describe Berkshelf::API::CacheManager do
  describe "ClassMethods" do
    describe "::new" do
      subject { described_class.new }
      its(:cache) { should be_empty }
      its(:builder) { should be_a(Berkshelf::API::CacheBuilder::Base) }

      it "tells the builder to begin building" do
        builder = double(archive_name: nil)
        described_class.any_instance.stub(:builder).and_return(builder)
        builder.should_receive(:async).with(:build)

        subject
      end

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

  describe "#builder" do
    subject { described_class.new.builder }

    it "should return an instance inheriting from CacheBuilder::Base" do
      should be_a(Berkshelf::API::CacheBuilder::Base)
    end
  end

  describe "#load_save" do
    pending
  end

  describe "#remove" do
    pending
  end
end
