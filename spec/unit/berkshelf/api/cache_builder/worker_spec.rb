require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::Base do
  let(:cache_manager) { double(:diff => :chicken) }
  subject { described_class.new }

  describe "#diff" do
    it "should delegate to the cache_manager to calculate the diff" do
      subject.should_receive(:cache_manager).and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      expect(subject.diff).to eql(:chicken)
    end

    it "should memoize the diff to prevent recalculating" do
      subject.should_receive(:cache_manager).exactly(1).times.and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      subject.diff
      subject.diff
    end
  end

  describe "#clear_diff" do
    it "should set the diff to nil" do
      subject.should_receive(:cache_manager).and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      subject.diff
      expect(subject.instance_variable_get(:@diff)).to eql(:chicken)
      subject.send(:clear_diff)
      expect(subject.instance_variable_get(:@diff)).to eql(nil)
    end

    it "memoizes the diff to prevent recalculating" do
      subject.should_receive(:cache_manager).exactly(1).times.and_return(cache_manager)
      subject.should_receive(:cookbooks).and_return(:cookbooks)

      subject.diff
      subject.diff
    end
  end
end
