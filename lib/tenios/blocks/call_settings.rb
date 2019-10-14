# frozen_string_literal: true

module Tenios
  class Blocks
    class CallSettings
      BLOCK_TYPE = 'CALL_SETTINGS'

      def initialize(forward_ani:)
        @forward_ani = forward_ani
      end

      def as_json(*)
        {
          blockType: BLOCK_TYPE,
          forwardAni: @forward_ani
        }
      end
    end
  end
end
