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

  subject { described_class.new }

  describe "#add" do
    pending
  end

  describe "#load_save" do
    pending
  end

  describe "#remove" do
    pending
  end

  describe "#clear" do
    it "returns an empty Hash" do
      result = subject.clear
      expect(result).to be_a(Hash)
      expect(result).to be_empty
    end

    it "empties the cache" do
      subject.clear
      expect(subject.cache).to be_empty
    end
  end

  describe "#diff" do
    let(:cookbook_one) { Berkshelf::API::RemoteCookbook.new("ruby", "1.2.3", "opscode") }
    let(:cookbook_two) { Berkshelf::API::RemoteCookbook.new("elixir", "2.0.0", "opscode") }
    let(:comparison) { Array.new }

    before do
      subject.add(cookbook_one, double(dependencies: nil, platforms: nil))
      subject.add(cookbook_two, double(dependencies: nil, platforms: nil))

      @created, @deleted = @diff = subject.diff(comparison)
    end

    it "returns two items" do
      expect(@diff).to have(2).items
    end

    context "when there are created and deleted cookbooks" do
      let(:new_cookbook) { Berkshelf::API::RemoteCookbook.new("ruby", "3.0.0", "opscode") }
      let(:comparison) { [ cookbook_one, new_cookbook ] }

      it "should return created and deleted cookbooks" do
        expect(@created).to eql([new_cookbook])
        expect(@deleted).to eql([cookbook_two])
      end
    end

    context "when there are only created cookbooks" do
      let(:new_cookbook) { Berkshelf::API::RemoteCookbook.new("ruby", "3.0.0", "opscode") }
      let(:comparison) { [ cookbook_one, cookbook_two, new_cookbook ] }

      it "should return only created cookbooks" do
        expect(@created).to eql([new_cookbook])
        expect(@deleted).to be_empty
      end
    end

    context "when there are only deleted cookbooks" do
      let(:comparison) { [ cookbook_one ] }

      it "should return only deleted cookbooks" do
        expect(@created).to be_empty
        expect(@deleted).to eql([cookbook_two])
      end
    end

    context "when there are no differences" do
      let(:comparison) { [ cookbook_one, cookbook_two ] }

      it "should return empty arrays" do
        expect(@created).to be_empty
        expect(@deleted).to be_empty
      end
    end
  end
end
