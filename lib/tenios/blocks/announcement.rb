# frozen_string_literal: true

module Tenios
  class Blocks
    class Announcement
      BLOCK_TYPE = "ANNOUNCEMENT"

      def initialize(announcement:, standard: false)
        @announcement = announcement
        @standard = !!standard
      end

      def as_json(*)
        {
          blockType: BLOCK_TYPE,
          standardAnnouncement: @standard,
          announcementName: @announcement
        }
      end
    end
  end
end
