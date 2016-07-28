require 'spec_helper'

describe Berkshelf::API::CacheManager do
  subject { described_class.new }

  describe "ClassMethods" do
    describe ".new" do
      it 'has an empty cache' do
        expect(subject.cache).to be_empty
      end

      context "when a save file exists" do
        before do
          @tempfile = Tempfile.new('berkshelf-api-rspec')
          allow(described_class).to receive(:cache_file) { @tempfile.path }
        end
        after { @tempfile.close(true) }

        it "loads the saved cache" do
          expect_any_instance_of(described_class).to receive(:load_save)
          subject
        end
      end

      context "when a save file does not exist" do
        before do
          allow(described_class).to receive(:cache_file).and_return(tmp_path.join('does_not_exist').to_s)
        end

        it "skips loading of the saved cache" do
          expect_any_instance_of(described_class).not_to receive(:load_save)
          subject
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

  it_behaves_like "a human-readable string"

  describe "#add" do
    skip
  end

  describe "#load_save" do
    skip
  end

  describe "#remove" do
    skip
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
    let(:cookbook_one) { Berkshelf::API::RemoteCookbook.new("ruby", "1.2.3", "supermarket", nil, 1) }
    let(:cookbook_two) { Berkshelf::API::RemoteCookbook.new("elixir", "2.0.0", "supermarket", nil, 1) }
    let(:comparison) { Array.new }

    before do
      subject.send(:add, cookbook_one, double(dependencies: nil, platforms: nil))
      subject.send(:add, cookbook_two, double(dependencies: nil, platforms: nil))

      @created, @deleted = @diff = subject.send(:diff, comparison, 1)
    end

    it "returns two items" do
      expect(@diff.size).to eq(2)
    end

    context "when there are more than one worker endpoints" do
      let(:new_cookbook) { Berkshelf::API::RemoteCookbook.new("ruby", "3.0.0", "supermarket", nil, 2) }
      let(:comparison) { [ cookbook_one, cookbook_two, new_cookbook ] }

      before do
        @created, @deleted = @diff = subject.send(:diff, comparison, 2)
      end

      it "only creates cookbooks that have the same or lower priority" do
        expect(@created).to eql([new_cookbook])
      end

      context "when the cookbook has been deleted" do
        let(:comparison) { [cookbook_one] }

        before do
         @created, @deleted = @diff = subject.send(:diff, comparison, 1)
        end

        it "only deletes cookbooks at the same priority" do
          expect(@deleted).to eql([cookbook_two])
        end
      end
    end

    context "when there are created and deleted cookbooks" do
      let(:new_cookbook) { Berkshelf::API::RemoteCookbook.new("ruby", "3.0.0", "supermarket", nil, 1) }
      let(:comparison) { [ cookbook_one, new_cookbook ] }

      it "should return created and deleted cookbooks" do
        expect(@created).to eql([new_cookbook])
        expect(@deleted).to eql([cookbook_two])
      end
    end

    context "when there are only created cookbooks" do
      let(:new_cookbook) { Berkshelf::API::RemoteCookbook.new("ruby", "3.0.0", "supermarket", nil, 1) }
      let(:comparison) { [ cookbook_one, cookbook_two, new_cookbook ] }

      it "should return only created cookbooks" do
        expect(@created).to eql([new_cookbook])
        expect(@deleted).to be_empty
      end
    end

    context "when there are only deleted cookbooks" do
      let(:comparison) { [ cookbook_one ] }

      before do
        @created, @deleted = @diff = subject.send(:diff, comparison, 1)
      end

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
