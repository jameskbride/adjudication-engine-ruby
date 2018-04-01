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

        @adjudicated_claims.push(claim)
        claim
      end

      private
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
