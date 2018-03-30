require "adjudication/claims/claim"

module Adjudication
  module Claims
    class Adjudicator

      def adjudicate(claim, providers)
        Claim.new(claim)
      end
    end
  end
end
