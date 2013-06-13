require 'spec_helper'

describe Berkshelf::API::Application do
  describe "ClassMethods" do
    subject { described_class }

    its(:registry) { should be_a(Celluloid::Registry) }

    describe "::parse_options" do
      let(:arguments) { Array.new }
      subject { described_class.parse_options(arguments) }

      it "returns a Hash" do
        expect(subject).to be_a(Hash)
      end

      context "given a value for -p" do
        let(:arguments) { ["-p", "1984"] }

        it "assigns the value as an integer to :port" do
          expect(subject).to have_key(:port)
          expect(subject[:port]).to eql(1984)
        end
      end
    end
  end
end
