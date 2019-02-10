# frozen_string_literal: true

module Tenios
  class Blocks
    class Bridge
      BLOCK_TYPE = 'BRIDGE'
      SEQUENTIAL = 'SEQUENTIAL'
      PARALLEL = 'PARALLEL'
      EXTERNAL_NUMBER = 'EXTERNALNUMBER'
      SIP_USER = 'SIP_USER'
      SIP_TRUNK = 'SIP_TRUNK'

      BRIDGE_MODES = [
        SEQUENTIAL,
        PARALLEL
      ].freeze

      DESTINATION_TYPES = [
        EXTERNAL_NUMBER,
        SIP_USER,
        SIP_TRUNK
      ].freeze

      def initialize(mode:, timeout: nil)
        @mode = mode
        @timeout = timeout
        @destinations = []

        raise "mode must be one of #{BRIDGE_MODES}" unless BRIDGE_MODES.include?(@mode)
        raise 'timeout is required' if parallel? && @timeout.nil?
        raise 'timeout is not accepted in this mode' if sequential? && !@timeout.nil?

        yield(self) if block_given?
      end

      def with_destination(destination_type, destination, timeout = nil)
        raise 'timeout is required' if sequential? && timeout.nil?
        raise 'timeout is not accepted' if parallel? && !timeout.nil?
        raise "destination_type must be one of #{DESTINATION_TYPES}" unless DESTINATION_TYPES.include?(destination_type)
        raise 'destination is required' if destination.strip.empty?

        @destinations << {
          destinationType: destination_type,
          destination: destination.strip,
          timeout: timeout
        }.compact

        self
      end

      def as_json(*)
        raise 'no destinations' if @destinations.empty?

        {
          blockType: BLOCK_TYPE,
          blockTimeout: @timeout,
          bridgeMode: @mode,
          destinations: @destinations
        }.compact
      end

      def sequential?
        @mode == SEQUENTIAL
      end

      def parallel?
        @mode == PARALLEL
      end
    end
  end
end
