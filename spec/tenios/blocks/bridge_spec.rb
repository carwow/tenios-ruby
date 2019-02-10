require 'spec_helper'
require 'securerandom'

RSpec.describe Tenios::Blocks::Bridge do
  let(:instance) { described_class.new(params) }

  describe 'block validations' do
    let(:params) do
      {
        mode: mode,
        timeout: timeout
      }
    end

    context 'in SEQUENTIAL mode' do
      let(:mode) { described_class::SEQUENTIAL }

      context 'when defining a timeout' do
        let(:timeout) { 10 }

        it 'raises' do
          expect { instance }.to raise_error('timeout is not accepted in this mode')
        end
      end

      context 'when not defining a timeout' do
        let(:timeout) { nil }

        it 'returns a valid instance' do
          expect(instance).to be_a(described_class)
        end
      end
    end

    context 'in PARALLEL mode' do
      let(:mode) { described_class::PARALLEL }

      context 'when defining a timeout' do
        let(:timeout) { 10 }

        it 'returns a valid instance' do
          expect(instance).to be_a(described_class)
        end
      end

      context 'when not defining a timeout' do
        let(:timeout) { nil }

        it 'raises' do
          expect { instance }.to raise_error('timeout is required')
        end
      end
    end

    context 'in unknown mode' do
      let(:mode) { SecureRandom.hex }
      let(:timeout) { nil }

      it 'raises' do
        expect { instance }.to raise_error("mode must be one of #{described_class::BRIDGE_MODES}")
      end
    end
  end

  describe '#with_destination' do
    subject(:result) { instance.with_destination(*destination_params) }

    let(:params) do
      {
        mode: described_class::SEQUENTIAL,
        timeout: nil
      }
    end

    let(:valid_destination_params) do
      [
        described_class::EXTERNAL_NUMBER,
        '+441234567890',
        10
      ]
    end

    describe 'destination_type' do
      context 'when known' do
        let(:destination_params) { valid_destination_params }

        it 'returns a valid instance' do
          expect(result).to be_a(described_class)
        end
      end

      context 'when unknown' do
        let(:destination_params) do
          valid_destination_params[0] = SecureRandom.hex
          valid_destination_params
        end

        it 'raises' do
          expect { result }.to raise_error("destination_type must be one of #{described_class::DESTINATION_TYPES}")
        end
      end
    end

    describe 'destination' do
      context 'when empty' do
        let(:destination_params) do
          valid_destination_params[1] = '  '
          valid_destination_params
        end

        it 'raises' do
          expect { result }.to raise_error('destination is required')
        end
      end

      context 'when not empty' do
        let(:destination_params) { valid_destination_params }

        it 'returns a valid instance' do
          expect(result).to be_a(described_class)
        end
      end
    end

    describe 'timeout' do
      context 'in SEQUENTIAL MODE' do
        context 'when set' do
          let(:destination_params) { valid_destination_params }

          it 'returns a valid instance' do
            expect(result).to be_a(described_class)
          end
        end

        context 'when not set' do
          let(:destination_params) do
            valid_destination_params[2] = nil
            valid_destination_params
          end

          it 'raises' do
            expect { result }.to raise_error('timeout is required')
          end
        end
      end

      context 'in PARALLEL MODE' do
        let(:params) { { mode: described_class::PARALLEL, timeout: 10 } }

        context 'when set' do
          let(:destination_params) { valid_destination_params }

          it 'raises' do
            expect { result }.to raise_error('timeout is not accepted')
          end
        end

        context 'when not set' do
          let(:destination_params) do
            valid_destination_params[2] = nil
            valid_destination_params
          end

          it 'returns a valid instance' do
            expect(result).to be_a(described_class)
          end
        end
      end
    end
  end

  describe '#as_json' do
    subject(:json) { instance.as_json }

    context 'with some destinations' do
      context 'when SEQUENTIAL' do
        let(:params) { { mode: described_class::SEQUENTIAL, timeout: nil } }
        let(:expected_json) do
          {
            blockType: described_class::BLOCK_TYPE,
            bridgeMode: described_class::SEQUENTIAL,
            destinations: [
              {
                destinationType: described_class::EXTERNAL_NUMBER,
                destination: '+0123456890',
                timeout: 10
              },
              {
                destinationType: described_class::SIP_USER,
                destination: 'beep',
                timeout: 11
              },
              {
                destinationType: described_class::SIP_TRUNK,
                destination: 'boop',
                timeout: 12
              }
            ]
          }
        end

        it 'returns a valid block' do
          instance
          .with_destination(described_class::EXTERNAL_NUMBER, '+0123456890', 10)
          .with_destination(described_class::SIP_USER, 'beep', 11)
          .with_destination(described_class::SIP_TRUNK, 'boop', 12)

          expect(json).to eq(expected_json)
        end
      end

      context 'when PARALLEL' do
        let(:params) { { mode: described_class::PARALLEL, timeout: 10 } }
        let(:expected_json) do
          {
            blockType: described_class::BLOCK_TYPE,
            bridgeMode: described_class::PARALLEL,
            blockTimeout: 10,
            destinations: [
              {
                destinationType: described_class::EXTERNAL_NUMBER,
                destination: '+0123456890'
              },
              {
                destinationType: described_class::SIP_USER,
                destination: 'beep'
              },
              {
                destinationType: described_class::SIP_TRUNK,
                destination: 'boop'
              }
            ]
          }
        end

        it 'returns a valid block' do
          instance
          .with_destination(described_class::EXTERNAL_NUMBER, '+0123456890')
          .with_destination(described_class::SIP_USER, 'beep')
          .with_destination(described_class::SIP_TRUNK, 'boop')

          expect(json).to eq(expected_json)
        end
      end
    end

    context 'without any destinations' do
      let(:params) { { mode: described_class::PARALLEL, timeout: 10 } }

      it 'raises' do
        expect { json }.to raise_error('no destinations')
      end
    end
  end
end
