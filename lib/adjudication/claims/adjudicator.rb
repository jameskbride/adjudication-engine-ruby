require "adjudication/claims/claim"

module Adjudication
  module Claims
    class Adjudicator

      def initialize
        @adjudicated_claims = []
      end

      def adjudicate(claim, providers)
        claim = Adjudication::Claims::Claim.new(claim)
        if !claim.in_network?(providers)
          claim.reject!
        end

        @adjudicated_claims.each {|adjudicated_claim|
          if claim.is_duplicate?(adjudicated_claim)
            claim.reject!
          end
        }

        @adjudicated_claims.push(claim)
        claim
      end
    end
  end
end
