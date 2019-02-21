# frozen_string_literal: true

%w[
  tenios/version
  tenios/blocks
  tenios/blocks/announcement
  tenios/blocks/bridge
  tenios/blocks/collect_digits
  tenios/blocks/collect_speech
  tenios/blocks/hang_up
  tenios/blocks/routing_plan
  tenios/blocks/say
].each { |f| require f }

module Tenios
  def self.blocks
    blocks = Blocks.new

    yield(blocks) if block_given?

    blocks
  end
end
