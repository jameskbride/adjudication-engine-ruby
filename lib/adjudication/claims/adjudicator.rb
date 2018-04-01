require "adjudication/claims/claim"

module Adjudication
  module Claims
    class Adjudicator

      ORTHO_PERCENT = 0.25

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

        log_rejections(claim)

        @adjudicated_claims.push(claim)
        claim
      end

      private
      def log_rejections(claim)
        rejected_line_items = claim.line_items
                                  .select {|line_item| line_item.is_rejected?}
        if (!rejected_line_items.empty?)
          $stderr.puts("\tClaim: #{claim.number}\n\t")
          rejected_line_items.each {|line_item|
            $stderr.puts("\tRejected line item: #{line_item.inspect}\n\t")
          }
        end
      end

      def process_line_item(line_item)
        if line_item.preventive_and_diagnostic?
          pay_preventative_and_diagnostics(line_item)
        elsif line_item.ortho?
          pay_orthodontics(line_item)
        else
          line_item.reject!
        end
      end

      def pay_preventative_and_diagnostics(line_item)
        line_item.pay!(line_item.charged)
      end

      def pay_orthodontics(line_item)
        line_item.pay!(line_item.charged * ORTHO_PERCENT)
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
