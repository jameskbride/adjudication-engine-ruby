require "adjudication/claims/claim_line_item"
require "set"

module Adjudication
  module Claims
    class Claim
      attr_accessor(
        :number,
        :provider,
        :subscriber,
        :patient,
        :start_date,
        :line_items
      )

      def initialize claim_hash
        @number = claim_hash['number']
        @provider = claim_hash['provider']
        @subscriber = claim_hash['subscriber']
        @patient = claim_hash['patient']
        @start_date = claim_hash['start_date']
        @line_items = claim_hash['line_items'].map{ |x| ClaimLineItem.new(x) }
      end

      def procedure_codes
        line_items.map(&:procedure_code)
      end

      def in_network?(providers = [])
        providers.collect {|provider| provider.npi}.include?(@provider)
      end

      def reject!
        @line_items.each{|line_item| line_item.reject!}
      end

      def is_rejected?
        @line_items.select{|line_item| line_item.is_rejected?}.length == @line_items.length
      end

      def is_duplicate?(claim)
        @start_date&.eql?(claim&.start_date) &&
            @patient['ssn'].eql?(claim.patient['ssn']) &&
            procedure_codes_match?(claim.line_items)
      end

      private
      def procedure_codes_match?(claim_line_items)
        procedure_codes = @line_items.collect {|line_item| line_item.procedure_code}.to_set
        other_procedure_codes = claim_line_items.collect {|line_item| line_item.procedure_code}.to_set

        procedure_codes == other_procedure_codes
      end
    end
  end
end
