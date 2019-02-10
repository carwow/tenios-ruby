# frozen_string_literal: true

module Tenios
  class Blocks
    class Say
      BLOCK_TYPE = 'SAY'

      def initialize(text:, voice:, ssml:)
        @text = text
        @voice = voice
        @ssml = !!ssml

        validate!
      end

      def as_json
        {
          blockType: BLOCK_TYPE,
          text: @text,
          voiceName: @voice,
          useSsml: @ssml
        }
      end

      private

      def validate!
        raise 'text is required' if @text.nil?
        raise 'voice is required' if @voice.nil?
      end
    end
  end
end
