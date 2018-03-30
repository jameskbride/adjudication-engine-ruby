require "spec_helper"
require "json"

RSpec.describe Adjudication::Engine do
  it "has a version number" do
    expect(Adjudication::Engine::VERSION).not_to be nil
  end

  describe "run" do

    context "when executed" do

      let(:claims_data) { build_claims_data }
      let(:adjudication_engine) { instance_double("AdjudicationEngine") }

      it "it returns all processed claims" do
        claims = [instance_double("Claim")]
        expect(adjudication_engine).to receive(:process).with(claims_data).and_return(claims)

        processed_claims = Adjudication::Engine::run(claims_data, adjudication_engine)

        expect(processed_claims).to eq(claims)
      end
    end
  end

  describe "AdjudicationEngine" do

    context "processing" do
      context "when processing claims" do

        let(:claims_data) { build_claims_data }
        let(:fetcher) { instance_double("Fetcher") }
        let(:adjudicator) { Adjudication::Claims::Adjudicator.new }
        let(:adjudication_engine) { Adjudication::Engine::AdjudicationEngine.new(adjudicator, fetcher) }

        it "it adjudicates all claims" do
          processed_claims = adjudication_engine.process(claims_data)
          expect(processed_claims.length).to eq(1)
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
