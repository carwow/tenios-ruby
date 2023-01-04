# frozen_string_literal: true

module Tenios
  class Blocks
    class RoutingPlan
      BLOCK_TYPE = "ROUTINGPLAN"

      def initialize(routing_plan:)
        raise "routing_plan is required" if routing_plan.nil?

        @routing_plan = routing_plan
      end

      def as_json(*)
        {
          blockType: BLOCK_TYPE,
          routingplanName: @routing_plan
        }
      end
    end
  end
end
