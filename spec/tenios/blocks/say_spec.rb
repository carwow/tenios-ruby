require 'spec_helper'

RSpec.describe Tenios::Blocks::Say do
  let(:instance) { described_class.new(params) }
  let(:valid_params) do
    {
      text: 'text',
      voice: 'voice',
      ssml: true
    }
  end

  describe 'validations' do
    describe 'text' do
      context 'when nil' do
        let(:params) { valid_params.merge(text: nil) }

        it 'raises' do
          expect { instance }.to raise_error('text is required')
        end
      end
    end

    describe 'voice' do
      context 'when nil' do
        let(:params) { valid_params.merge(voice: nil) }

        it 'raises' do
          expect { instance }.to raise_error('voice is required')
        end
      end
    end
  end

  describe 'as_json' do
    subject(:json) { instance.as_json }

    let(:params) { valid_params }
    let(:expected_json) do
      {
        blockType: described_class::BLOCK_TYPE,
        text: params[:text],
        voiceName: params[:voice],
        useSsml: params[:ssml]
      }
    end

    it 'returns a valid block' do
      expect(json).to eq(expected_json)
    end
  end
end
