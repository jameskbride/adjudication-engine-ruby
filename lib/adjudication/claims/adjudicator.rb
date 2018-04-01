require "adjudication/claims/claim"

module Adjudication
  module Claims
    class Adjudicator

      def initialize
        @adjudicated_claims = []
      end

      def adjudicate(claim, providers)
        claim = Adjudication::Claims::Claim.new(claim)
        reject_out_of_network_claims(claim, providers)
        reject_duplicate_claims(claim)

        if !claim.is_rejected?
          claim.line_items.each {|line_item|
            process_line_item(line_item)
          }
        end

        @adjudicated_claims.push(claim)
        claim
      end

      private
      def process_line_item(line_item)
        if line_item.preventive_and_diagnostic?
          line_item.pay!(line_item.charged)
        end
      end

      def reject_duplicate_claims(claim)
        @adjudicated_claims.each {|adjudicated_claim|
          if claim.is_duplicate?(adjudicated_claim)
            claim.reject!
          end
        }
      end

      def reject_out_of_network_claims(claim, providers)
        if !claim.in_network?(providers)
          claim.reject!
        end
      end
    end
  end
end
