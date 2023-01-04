require "spec_helper"
require "securerandom"

RSpec.describe Tenios::Blocks::HangUp do
  let(:instance) { described_class.new(**params) }

  let(:valid_params) { {cause: described_class::NO_ANSWER} }

  describe "validations" do
    let(:params) { valid_params }

    it "returns a valid instance" do
      expect(instance).to be_a(described_class)
    end

    describe "cause" do
      context "when cause is not a known value" do
        let(:params) { valid_params.merge(cause: SecureRandom.hex) }

        it "raises" do
          expect { instance }.to raise_error("cause must be one of #{described_class::CAUSES}")
        end
      end
    end
  end

  describe "#as_json" do
    subject(:json) { instance.as_json }

    let(:params) { valid_params }

    it "returns a valid block" do
      expect(json).to eq(
        blockType: described_class::BLOCK_TYPE,
        hangupCause: valid_params[:cause]
      )
    end
  end
end
