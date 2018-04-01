require "spec_helper"

RSpec.describe Adjudication::Claims::Adjudicator do

  describe "Adjudication" do

    IN_NETWORK_PROVIDER_NPI = "0123456789"

    let(:claim_data) { Adjudication::TestUtils.build_claim_data }
    let(:adjudicator) { Adjudication::Claims::Adjudicator.new }
    let(:providers) { [Adjudication::Providers::Provider.new(IN_NETWORK_PROVIDER_NPI)] }

    context "Valid claims" do
      it "it adjudicates a valid claim" do
        claim_data['provider'] = IN_NETWORK_PROVIDER_NPI

        claim = adjudicator.adjudicate(claim_data, providers)

        expect(claim.number).to eq(claim_data['number'])
        expect(claim.provider).to eq(claim_data['provider'])
        expect(claim.subscriber).to eq(claim_data['subscriber'])
        expect(claim.patient).to eq(claim_data['patient'])
        expect(claim.start_date).to eq(claim_data['start_date'])
      end

      it "it fully pays preventative and diagnostic claim line items" do
        claim_data['provider'] = IN_NETWORK_PROVIDER_NPI

        preventative_line_item = Adjudication::TestUtils.build_claim_line_item_data("D1110", 16, 47)
        diagnostic_line_item = Adjudication::TestUtils.build_claim_line_item_data("A1999", nil, 100)
        claim_data['line_items'] = [preventative_line_item, diagnostic_line_item]

        claim = adjudicator.adjudicate(claim_data, providers)
        expect(claim.line_items.length).to eq(2)
        expect(claim.line_items[0].carrier_paid).to eq(47)
        expect(claim.line_items[0].patient_paid).to eq(0)

        expect(claim.line_items[1].carrier_paid).to eq(100)
        expect(claim.line_items[1].patient_paid).to eq(0)
      end
    end

    context "Network status" do
      it "it rejects out of network claims" do
        claim_data['provider'] = "9876543210"

        claim = adjudicator.adjudicate(claim_data, providers)

        expect(claim.is_rejected?).to eq(true)
      end
    end

    context "Duplicate claims" do

      it "it rejects claims that are duplicates of a previously processed claim" do
        claim_data['provider'] = IN_NETWORK_PROVIDER_NPI
        duplicate_claim_data = Adjudication::TestUtils.build_claim_data
        duplicate_claim_data['provider'] = IN_NETWORK_PROVIDER_NPI

        original_claim = adjudicator.adjudicate(claim_data, providers)
        duplicate_claim = adjudicator.adjudicate(duplicate_claim_data, providers)

        expect(original_claim.is_rejected?).to eq(false)
        expect(duplicate_claim.is_rejected?).to eq(true)
      end

    end
  end
end