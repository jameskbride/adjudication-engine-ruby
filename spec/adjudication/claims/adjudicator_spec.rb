require "spec_helper"

RSpec.describe Adjudication::Claims::Adjudicator do

  describe "Adjudication" do

    let(:claim_data) {Adjudication::TestUtils.build_claim_data}
    let(:adjudicator) { Adjudication::Claims::Adjudicator.new }

    it "it adjudicates a valid claim" do
      providers = [Adjudication::Providers::Provider.new("1811052616")]

      claim = adjudicator.adjudicate(claim_data, providers)

      expect(claim.number).to eq(claim_data['number'])
      expect(claim.provider).to eq(claim_data['provider'])
      expect(claim.subscriber).to eq(claim_data['subscriber'])
      expect(claim.patient).to eq(claim_data['patient'])
      expect(claim.start_date).to eq(claim_data['start_date'])
    end

    it "it rejects out of network claims" do
      providers = [Adjudication::Providers::Provider.new("0123456789")]
      claim_data['provider'] = "9876543210"

      claim = adjudicator.adjudicate(claim_data, providers)

      expect(claim.is_rejected?).to eq(true)
    end
  end
end