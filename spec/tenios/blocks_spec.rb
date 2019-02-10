require 'spec_helper'

RSpec.describe Tenios::Blocks do
  let(:instance) { described_class.new }

  describe '#add' do
    subject(:add) { instance.add(block) }

    let(:block) { 'hello' }

    it 'returns self' do
      expect(add).to be_a(described_class)
    end
  end

  describe '#as_json' do
    subject(:json) { instance.as_json }

    let(:block_1) { instance_double('Tenios::Blocks', as_json: 'block_1') }
    let(:block_2) { instance_double('Tenios::Blocks', as_json: 'block_2') }
    let(:expected_json) do
      {
        blocks: %w[
          block_1
          block_2
        ]
      }
    end

    it 'returns blocks' do
      instance
      .add(block_1)
      .add(block_2)

      expect(json).to eq(expected_json)
    end
  end
end
