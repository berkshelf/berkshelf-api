require 'spec_helper'

describe Berkshelf::API::RackApp do
  subject { described_class }
  its(:endpoints) { should have(1).item.at_least }
end
