require 'spec_helper'

describe Berkshelf::API::SrvCtl do
  describe "ClassMethods" do
    describe "::parse_options" do
      let(:args) { Array.new }
      let(:filename) { "berks-api" }

      subject { described_class.parse_options(args, filename) }

      it "returns a hash" do
        expect(subject).to be_a(Hash)
      end

      context "given -p" do
        let(:args) { ["-p", "1234"] }

        it "sets :pid_file to the given value" do
          expect(subject[:port]).to eql(1234)
        end
      end

      context "given -v" do
        let(:args) { ["-v"] }

        it "sets :log_level to INFO" do
          expect(subject[:log_level]).to eql("INFO")
        end
      end

      context "given -d" do
        let(:args) { ["-d"] }

        it "sets :log_level to DEBUG" do
          expect(subject[:log_level]).to eql("DEBUG")
        end
      end

      context "given -q" do
        let(:args) { ["-q"] }

        it "sets :log_location to /dev/null" do
          expect(subject[:log_location]).to eql("/dev/null")
        end
      end

      context "given -v and -d" do
        let(:args) { ["-v", "-d"] }

        it "sets :log_level to DEBUG" do
          expect(subject[:log_level]).to eql("DEBUG")
        end
      end

      context "given -c" do
        let(:args) { ["-c", "/path/to/config"] }

        it "sets :config_file to the given value" do
          expect(subject[:config_file]).to eql("/path/to/config")
        end
      end
    end
  end
end
