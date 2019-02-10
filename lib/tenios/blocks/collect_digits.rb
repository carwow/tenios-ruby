# frozen_string_literal: true

module Tenios
  class Blocks
    class CollectDigits
      BLOCK_TYPE = 'COLLECT_DIGITS'
      VARIABLE_REGEX = /^[a-z0-9_]+$/.freeze
      TERMINATORS = %w[# *].freeze

      def initialize(
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
        @announcement = announcement
        @standard_announcement = !!standard_announcement
        @error_announcement = error_announcement
        @standard_error_announcement = !!standard_error_announcement
        @variable = variable
        @min_digits = min_digits
        @max_digits = max_digits
        @terminator = terminator
        @max_tries = max_tries
        @timeout = timeout

        validate!
      end

      def as_json(*)
        {
          blockType: BLOCK_TYPE,
          standardAnnouncement: @standard_announcement,
          announcementName: @announcement,
          standardErrorAnnouncement: @standard_error_announcement,
          errorAnnouncementName: @error_announcement,
          variableName: @variable,
          minDigits: @min_digits,
          maxDigits: @max_digits,
          terminator: @terminator,
          timeout: @timeout,
          maxTries: @max_tries
        }
      end

      def validate!
        raise 'min_digits must be between 1-32 (inclusive)' unless (1..32).cover?(@min_digits)
        raise 'max_digits must be between 1-32 (inclusive)' unless (1..32).cover?(@max_digits)
        raise 'min_digits must be less than or equal to max_digits' unless @min_digits <= @max_digits
        raise "terminator must be one of #{TERMINATORS}" unless TERMINATORS.include?(@terminator)
        raise "variable must match #{VARIABLE_REGEX.inspect}" unless @variable.match?(VARIABLE_REGEX)
        raise 'max_tries must be between 1-10 (inclusive)' unless (1..10).cover?(@max_tries)
        raise 'timeout must be between 0-300 (inclusive)' unless (1..300).cover?(@timeout)
        raise 'announcement is required' if @announcement.nil?
        raise 'error_announcement is required' if @error_announcement.nil?
      end
    end
  end
end
