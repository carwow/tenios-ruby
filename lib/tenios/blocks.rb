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

    def as_json(*)
      {
        blocks: @blocks.map(&:as_json)
      }
    end
  end
end
