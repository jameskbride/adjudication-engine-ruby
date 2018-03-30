module Adjudication
  module Claims
    class Adjudicator

      def adjudicate(claim)
        Claim.new(claim)
      end
    end
  end
end
