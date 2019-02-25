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

  describe '#announce' do
    it 'adds an announcement block' do
      instance.announce(announcement: 'hello', standard: true)

      announcement = Tenios::Blocks::Announcement.new(
        announcement: 'hello',
        standard: true
      )

      blocks = described_class.new
      blocks.add(announcement)

      expect(instance.as_json).to eq(blocks.as_json)
    end
  end

  describe '#bridge' do
    it 'adds a bridge block' do
    end

    it 'yields an instance of Tenios::Blocks::Bridge' do
      expect { |b| instance.bridge(mode: Tenios::Blocks::Bridge::SEQUENTIAL, &b) }
        .to yield_control.once

      expect { |b| instance.bridge(mode: Tenios::Blocks::Bridge::SEQUENTIAL, &b) }
        .to yield_with_args(Tenios::Blocks::Bridge)
    end
  end

  describe '#collect_digits' do
    it 'adds a collect_digits block' do
      instance.collect_digits(
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
      )

      collect_digits = Tenios::Blocks::CollectDigits.new(
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
      )

      blocks = described_class.new
      blocks.add(collect_digits)

      expect(instance.as_json).to eq(blocks.as_json)
    end
  end

  describe '#collect_speech' do
    pending
  end

  describe '#hang_up' do
    it 'adds a hang_up block' do
      instance.hang_up(cause: Tenios::Blocks::HangUp::NO_ANSWER)

      hang_up = Tenios::Blocks::HangUp.new(
        cause: Tenios::Blocks::HangUp::NO_ANSWER
      )

      blocks = described_class.new
      blocks.add(hang_up)

      expect(instance.as_json).to eq(blocks.as_json)
    end
  end

  describe '#routing_plan' do
    it 'adds a routing_plan block' do
      instance.routing_plan(routing_plan: 'hello')

      routing_plan = Tenios::Blocks::RoutingPlan.new(
        routing_plan: 'hello'
      )

      blocks = described_class.new
      blocks.add(routing_plan)

      expect(instance.as_json).to eq(blocks.as_json)
    end
  end

  describe '#say' do
    it 'adds a say block' do
      instance.say(text: 'hello', voice: 'voice', ssml: false)

      say = Tenios::Blocks::Say.new(
        text: 'hello',
        voice: 'voice',
        ssml: false
      )

      blocks = described_class.new
      blocks.add(say)

      expect(instance.as_json).to eq(blocks.as_json)
    end
  end
end
