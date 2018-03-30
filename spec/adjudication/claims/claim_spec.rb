require "spec_helper"

RSpec.describe Adjudication::Claims::Claim do

  context "covered in-network" do

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

    it "it can reject all line items" do
      claim = Adjudication::Claims::Claim.new(claim_data)

      claim.reject!

      expect(claim.is_rejected?).to eq(true)
    end
  end
end