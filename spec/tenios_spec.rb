require 'spec_helper'

RSpec.describe Tenios do
  describe '.blocks' do
    it 'yields an instance of Tenios::Blocks' do
      expect { |b| described_class.blocks(&b) }.to yield_control.once
      expect { |b| described_class.blocks(&b) }.to yield_with_args(Tenios::Blocks)
    end

    it 'return an instance of Tenios::Blocks' do
      blocks = described_class.blocks {}
      expect(blocks).to be_a(Tenios::Blocks)
    end

    it 'returns the yielded instance of Tenios::Blocks' do
      yielded_blocks = described_class.blocks do |block|
        block.announce(announcement: 'hello')
      end

      blocks = Tenios::Blocks.new
      announcement = Tenios::Blocks::Announcement.new(announcement: 'hello')

      blocks.add(announcement)

      expect(yielded_blocks).to be_a(Tenios::Blocks)
      expect(yielded_blocks.as_json).to eq(blocks.as_json)
    end
  end
end
