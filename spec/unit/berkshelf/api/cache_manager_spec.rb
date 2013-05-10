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

    describe "::instance" do
      subject { described_class.instance }
      context "when the cache manager is started" do
        before { described_class.start }

        it "returns the instance of cache manager" do
          expect(subject).to be_a(described_class)
        end
      end

      context "when the cache manager is not started" do
        before { Berkshelf::API::Application.stub(:[]).with(:cache_manager).and_return(nil) }

        it "raises a NotStartedError" do
          expect { subject }.to raise_error(Berkshelf::NotStartedError)
        end
      end
    end

    describe "::start" do
      it "starts and registers a cache manager it with the application" do
        described_class.start

        expect(Berkshelf::API::Application[:cache_manager]).to be_a(described_class)
        expect(Berkshelf::API::Application[:cache_manager]).to be_alive
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
