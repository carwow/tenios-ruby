require 'spec_helper'
require 'securerandom'

RSpec.describe Tenios::Blocks::RoutingPlan do
  let(:instance) { described_class.new(**params) }
  let(:valid_params) { { routing_plan: SecureRandom.hex } }

  describe 'validations' do
    describe 'routing_plan' do
      context 'when not set' do
        let(:params) { valid_params.merge(routing_plan: nil) }

        it 'raises' do
          expect { instance }.to raise_error('routing_plan is required')
        end
      end
    end
  end

  describe '#as_json' do
    subject(:json) { instance.as_json }

    let(:params) { valid_params }

    it 'returns a valid block' do
      expect(json).to eq(
        blockType: described_class::BLOCK_TYPE,
        routingplanName: params[:routing_plan]
      )
    end
  end
end
