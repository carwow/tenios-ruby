require 'spec_helper'

RSpec.describe Tenios::Blocks::CallSettings do
  let(:instance) { described_class.new(params) }
  let(:valid_params) do
    {
      forward_ani: '+123'
    }
  end

  describe 'as_json' do
    subject(:json) { instance.as_json }

    let(:params) { valid_params }
    let(:expected_json) do
      {
        blockType: described_class::BLOCK_TYPE,
        forwardAni: params[:forward_ani]
      }
    end

    it 'returns a valid block' do
      expect(json).to eq(expected_json)
    end
  end
end
