require 'spec_helper'

describe Berkshelf::API::CacheManager do
  describe "ClassMethods" do
    describe "::new" do
      subject { described_class.new }
      its(:cache) { should be_empty }

      context "when a save file exists" do
        before do
          @tempfile = Tempfile.new('berkshelf-api-rspec')
          described_class.stub(:cache_file) { @tempfile.path }
        end
        after { @tempfile.close(true) }

        it "loads the saved cache" do
          described_class.any_instance.should_receive(:load_save)
          subject
        end
      end

      context "when a save file does not exist" do
        before { described_class.stub(cache_file: tmp_path.join('does_not_exist').to_s) }

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
          expect { subject }.to raise_error(Berkshelf::API::NotStartedError)
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

  describe "#diff" do
    let(:known_cookbooks) { [ :chicken_1, :tuna_3 ] }
    let(:cache) { double("cache", :cookbooks => known_cookbooks) }
    subject { described_class.new }

    context "when there are created and deleted cookbooks" do
      it "should return created and deleted cookbooks" do
        subject.should_receive(:cache).and_return(cache)

        site_cookbooks = [ :tuna_3, :tuna_4 ]

        diff = subject.diff(site_cookbooks)
        expect(diff.size).to eql(2)
        expect(diff.first).to eql([:tuna_4])
        expect(diff.last).to eql([:chicken_1])
      end
    end

    context "when there are only created cookbooks" do
      it "should return only created cookbooks" do
        subject.should_receive(:cache).and_return(cache)

        site_cookbooks = [ :chicken_1, :tuna_3, :tuna_4 ]

        diff = subject.diff(site_cookbooks)
        expect(diff.size).to eql(2)
        expect(diff.first).to eql([:tuna_4])
        expect(diff.last).to be_empty
      end
    end

    context "when there are only deleted cookbooks" do
      it "should return only deleted cookbooks" do
        subject.should_receive(:cache).and_return(cache)

        site_cookbooks = [ :tuna_3 ]

        diff = subject.diff(site_cookbooks)
        expect(diff.size).to eql(2)
        expect(diff.first).to be_empty
        expect(diff.last).to eql([:chicken_1])
      end
    end

    context "when there are no differences" do
      it "should return empty arrays" do
        subject.should_receive(:cache).and_return(cache)

        site_cookbooks = [ :chicken_1, :tuna_3 ]

        diff = subject.diff(site_cookbooks)
        expect(diff.size).to eql(2)
        expect(diff.first).to be_empty
        expect(diff.last).to be_empty
      end
    end

  end
end
