require "adjudication/claims/claim"

module Adjudication
  module Claims
    class Adjudicator

      def adjudicate(claim, providers)
        claim = Claim.new(claim)
        if !claim.in_network?(providers)
          claim.reject!
        end

        claim
      end
    end
  end
end
