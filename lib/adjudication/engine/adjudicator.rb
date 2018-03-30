module Adjudication
  module Engine
    class Adjudicator

      def adjudicate(claim)
        Claim.new(claim)
      end
    end
  end
end
