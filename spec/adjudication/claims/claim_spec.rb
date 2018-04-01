require "spec_helper"

RSpec.describe Adjudication::Claims::Claim do

  context "Network status" do

    it "it is in-network when it has an in-network provider" do
      in_network_npi = "0123456789"
      claim_data = Adjudication::TestUtils::build_claim_data
      claim_data['provider'] = in_network_npi

      claim = Adjudication::Claims::Claim.new(claim_data)

      providers = [Adjudication::Providers::Provider.new(in_network_npi)]

      expect(claim.in_network?(providers)).to eq(true)
    end

    it "it is not in-network when it does not have an in-network provider" do
      claim_data = Adjudication::TestUtils::build_claim_data
      claim_data['provider'] = "9876543210"

      claim = Adjudication::Claims::Claim.new(claim_data)

      in_network_npi = "0123456789"
      providers = [Adjudication::Providers::Provider.new(in_network_npi)]

      expect(claim.in_network?(providers)).to eq(false)
    end
  end

  context "Rejected status" do

    let(:claim_data) {Adjudication::TestUtils::build_claim_data}
    it "it is rejected when all line items are rejected" do
      claim = Adjudication::Claims::Claim.new(claim_data)
      claim.line_items.each {|line_item| line_item.reject!}

      expect(claim.is_rejected?).to eq(true)
    end

    it "it is not rejected when at least one line item is not rejected" do
      claim = Adjudication::Claims::Claim.new(claim_data)
      claim.line_items[0].reject!

      expect(claim.is_rejected?).to eq(false)
    end

    it "it can reject all line items" do
      claim = Adjudication::Claims::Claim.new(claim_data)

      claim.reject!

      expect(claim.is_rejected?).to eq(true)
    end
  end

  context "Duplicate status" do

    let(:claim_data) {Adjudication::TestUtils::build_claim_data}
    let(:claim) { Adjudication::Claims::Claim.new(claim_data)}
    it "it is a duplicate when it has the same start_date, patient SSN, and procedure codes as a another claim" do
      other_claim = Adjudication::Claims::Claim.new(claim_data)

      expect(claim.is_duplicate?(other_claim)).to eq(true)
    end

    it "it is not a duplicate when it has a different start_date" do
      other_claim_data = Adjudication::TestUtils.build_claim_data
      other_claim_data['start_date'] = "2017-09-13"
      other_claim = Adjudication::Claims::Claim.new(other_claim_data)

      expect(claim.is_duplicate?(other_claim)).to eq(false)
    end

    it "it is not a duplicate when it has a different patient SSN" do
      other_claim_data = Adjudication::TestUtils.build_claim_data
      other_claim_data['patient']['ssn'] = "123-45-6789"
      other_claim = Adjudication::Claims::Claim.new(other_claim_data)

      expect(claim.is_duplicate?(other_claim)).to eq(false)
    end

    it "it is not a duplicate when it has different procedure codes" do
      other_claim_data = Adjudication::TestUtils.build_claim_data
      other_claim_data['line_items'][0]['procedure_code'] = "X1234"
      other_claim = Adjudication::Claims::Claim.new(other_claim_data)

      expect(claim.is_duplicate?(other_claim)).to eq(false)
    end
  end
end