# frozen_string_literal: true

module Tenios
  class Blocks
    def initialize
      @blocks = []

      yield(self) if block_given?
    end

    def add(block)
      @blocks << block

      self
    end

    def announce(announcement:, standard: false)
      block = Announcement.new(
        announcement: announcement,
        standard: standard
      )

      add(block)
    end

    def bridge(mode:, timeout: nil)
      block = Bridge.new(
        mode: mode,
        timeout: timeout
      )

      yield(block) if block_given?

      add(block)
    end

    def collect_digits(
      announcement:,
      standard_announcement:,
      error_announcement:,
      standard_error_announcement:,
      variable:,
      min_digits:,
      max_digits:,
      terminator:,
      max_tries:,
      timeout:
    )
      block = CollectDigits.new(
        announcement: announcement,
        standard_announcement: standard_announcement,
        error_announcement: error_announcement,
        standard_error_announcement: standard_error_announcement,
        variable: variable,
        min_digits: min_digits,
        max_digits: max_digits,
        terminator: terminator,
        max_tries: max_tries,
        timeout: timeout
      )

      add(block)
    end

    def collect_speech(
      announcement:,
      missing_input_announcement:,
      language:,
      variable:,
      max_tries:
    )
      block = CollectSpeech.new(
        announcement: announcement,
        missing_input_announcement: missing_input_announcement,
        language: language,
        variable: variable,
        max_tries: max_tries
      )

      add(block)
    end

    def hang_up(cause:)
      block = HangUp.new(cause: cause)

      add(block)
    end

    def routing_plan(routing_plan:)
      block = RoutingPlan.new(routing_plan: routing_plan)

      add(block)
    end

    def say(text:, voice:, ssml:)
      block = Say.new(text: text, voice: voice, ssml: ssml)

      add(block)
    end

    def as_json(*)
      {
        blocks: @blocks.map(&:as_json)
      }
    end
  end
end
