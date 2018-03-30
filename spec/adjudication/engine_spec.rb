require "spec_helper"
require "json"

RSpec.describe Adjudication::Engine do
  it "has a version number" do
    expect(Adjudication::Engine::VERSION).not_to be nil
  end

  describe "AdjudicationEngine" do

    context "processing" do
      context "when processing claims" do

        let(:claims_data) { build_claims_data }
        let(:fetcher) { instance_double("Fetcher") }
        let(:provider_manager) { instance_double("ProviderManager") }
        let(:adjudicator) { instance_double("Adjudicator") }
        let(:adjudication_engine) { Adjudication::Engine::AdjudicationEngine.new(adjudicator, provider_manager) }

        it "it adjudicates all claims" do
          providers = [Adjudication::Providers::Provider.new("1811052616")]
          expect(provider_manager).to receive(:retrieve_providers).and_return(providers)

          claim = instance_double("Claim")
          expect(adjudicator).to receive(:adjudicate).with(claims_data[0], providers).and_return(claim)

          processed_claims = adjudication_engine.process(claims_data)
          expect(processed_claims[0]).to eq(claim)
        end
      end
    end
  end

  def build_claims_data
    parsed_claim = JSON.parse('{
    "npi": "1811052616",
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
    [parsed_claim]
  end
end
