require 'spec_helper'

describe Berkshelf::API::Application do
  describe "ClassMethods" do
    subject { described_class }

    its(:registry) { should be_a(Celluloid::Registry) }
  end
end
