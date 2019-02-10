require 'spec_helper'

RSpec.describe Tenios::Blocks::Announcement do
  let(:instance) { described_class.new(**params) }

  describe '#as_json' do
    subject(:json) { instance.as_json }

    let(:params) { { announcement: 'boop' } }

    it 'returns a valid block' do
      expect(json).to eq(
        blockType: described_class::BLOCK_TYPE,
        standardAnnouncement: false,
        announcementName: 'boop'
      )
    end
  end
end
