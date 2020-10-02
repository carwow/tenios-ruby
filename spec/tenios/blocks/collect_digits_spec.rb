require 'spec_helper'

RSpec.describe Tenios::Blocks::CollectDigits do
  let(:instance) { described_class.new(**params) }
  let(:valid_params) do
    {
      announcement: 'announcement',
      standard_announcement: true,
      error_announcement: 'error_announcement',
      standard_error_announcement: false,
      variable: 'variable',
      min_digits: 1,
      max_digits: 32,
      terminator: '#',
      max_tries: 10,
      timeout: 300
    }
  end

  describe 'validations' do
    let(:params) { valid_params }

    it 'returns a valid instance' do
      expect(instance).to be_a(described_class)
    end

    describe 'announcement' do
      context 'when not set' do
        let(:params) { valid_params.merge(announcement: nil) }

        it 'raises' do
          expect { instance }.to raise_error('announcement is required')
        end
      end
    end

    describe 'error_announcement' do
      context 'when not set' do
        let(:params) { valid_params.merge(error_announcement: nil) }

        it 'raises' do
          expect { instance }.to raise_error('error_announcement is required')
        end
      end
    end

    describe 'variable' do
      context 'when containing invalid characters' do
        let(:params) { valid_params.merge(variable: 'A') }

        it 'raises' do
          expect { instance }.to raise_error("variable must match #{described_class::VARIABLE_REGEX.inspect}")
        end
      end
    end

    describe 'min_digits' do
      context 'when too low' do
        let(:params) { valid_params.merge(min_digits: 0) }

        it 'raises' do
          expect { instance }.to raise_error('min_digits must be between 1-32 (inclusive)')
        end
      end

      context 'when too high' do
        let(:params) { valid_params.merge(min_digits: 33) }

        it 'raises' do
          expect { instance }.to raise_error('min_digits must be between 1-32 (inclusive)')
        end
      end

      context 'when higher than max_digits' do
        let(:params) { valid_params.merge(min_digits: 2, max_digits: 1) }

        it 'raises' do
          expect { instance }.to raise_error('min_digits must be less than or equal to max_digits')
        end
      end
    end

    describe 'max_digits' do
      context 'when too low' do
        let(:params) { valid_params.merge(max_digits: 0) }

        it 'raises' do
          expect { instance }.to raise_error('max_digits must be between 1-32 (inclusive)')
        end
      end

      context 'when too high' do
        let(:params) { valid_params.merge(max_digits: 33) }

        it 'raises' do
          expect { instance }.to raise_error('max_digits must be between 1-32 (inclusive)')
        end
      end
    end

    describe 'terminator' do
      context 'when unknown' do
        let(:params) { valid_params.merge(terminator: nil) }

        it 'raises' do
          expect { instance }.to raise_error("terminator must be one of #{described_class::TERMINATORS}")
        end
      end
    end

    describe 'timeout' do
      context 'when too high' do
        let(:params) { valid_params.merge(timeout: 301) }

        it 'raises' do
          expect { instance }.to raise_error('timeout must be between 0-300 (inclusive)')
        end
      end

      context 'when too low' do
        let(:params) { valid_params.merge(timeout: -1) }

        it 'raises' do
          expect { instance }.to raise_error('timeout must be between 0-300 (inclusive)')
        end
      end
    end

    describe 'max_tries' do
      context 'when too high' do
        let(:params) { valid_params.merge(max_tries: 11) }

        it 'raises' do
          expect { instance }.to raise_error('max_tries must be between 1-10 (inclusive)')
        end
      end

      context 'when too low' do
        let(:params) { valid_params.merge(max_tries: 0) }

        it 'raises' do
          expect { instance }.to raise_error('max_tries must be between 1-10 (inclusive)')
        end
      end
    end
  end

  describe '#as_json' do
    subject(:json) { instance.as_json }

    let(:params) { valid_params }
    let(:expected_json) do
      {
        blockType: described_class::BLOCK_TYPE,
        standardAnnouncement: true,
        announcementName: 'announcement',
        standardErrorAnnouncement: false,
        errorAnnouncementName: 'error_announcement',
        variableName: 'variable',
        minDigits: 1,
        maxDigits: 32,
        terminator: '#',
        timeout: 300,
        maxTries: 10
      }
    end

    it 'returns a valid block' do
      expect(json).to eq(expected_json)
    end
  end
end
