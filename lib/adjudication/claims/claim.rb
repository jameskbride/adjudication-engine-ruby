require "adjudication/claims/claim_line_item"

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
    end
  end
end
