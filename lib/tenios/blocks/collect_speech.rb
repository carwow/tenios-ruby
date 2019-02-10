# frozen_string_literal: true

module Tenios
  class Blocks
    class CollectSpeech
      BLOCK_TYPE = 'COLLECT_SPEECH'

      def initialize(
        announcement:,
        missing_input_announcement:,
        language:,
        variable:,
        max_tries:
      )
        @announcement = announcement
        @missing_input_announcement = missing_input_announcement
        @language = language
        @variable = variable
        @max_tries = max_tries
      end

      def as_json
        {
          blockType: BLOCK_TYPE,
          standardAnnouncement: false,
          announcementName: @announcement,
          standardMissingInputAnnouncement: false,
          missingInputAnnouncementName: @missing_input_announcement,
          language: @language,
          variableName: @variable,
          maxTries: @max_tries
        }
      end
    end
  end
end
