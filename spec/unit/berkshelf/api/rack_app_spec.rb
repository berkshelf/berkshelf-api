require 'spec_helper'

describe Berkshelf::API::RackApp do
  describe '.endpoints' do
    it 'has at least one item' do
      expect(described_class.endpoints.size).to be > 0
    end
  end
end
