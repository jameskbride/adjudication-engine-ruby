require "spec_helper"

RSpec.describe Adjudication::Claims::Adjudicator do

  describe "Adjudication" do

    let(:claim_data) {build_claim_data}
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
  end

  def build_claim_data
    parsed_claim = JSON.parse('{
    "provider": "1811052616",
    "number": "2017-09-01-123214",
    "start_date": "2017-09-01",
    "subscriber": {
      "ssn": "000-11-7777",
      "group_number": "US00123"
    },
    "patient": {
      "ssn": "000-12-5555",
      "relationship": "spouse"
    },
    "line_items": [
      {
        "procedure_code": "D1110",
        "tooth_code": null,
        "charged": 47
      },
      {
        "procedure_code": "D0120",
        "tooth_code": null,
        "charged": 25
      }
    ]
  }')
    parsed_claim
  end
end