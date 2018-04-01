require "spec_helper"
require "json"

RSpec.describe Adjudication::Engine do
  it "has a version number" do
    expect(Adjudication::Engine::VERSION).not_to be nil
  end

  describe "AdjudicationEngine" do

    let(:claims_data) { [Adjudication::TestUtils.build_claim_data] }
    let(:fetcher) { instance_double("Fetcher") }
    let(:provider_manager) { instance_double("ProviderManager") }
    let(:adjudicator) { instance_double("Adjudicator") }
    let(:adjudication_engine) { Adjudication::Engine::AdjudicationEngine.new(adjudicator, provider_manager) }

    context "processing" do
      context "when processing claims" do

        it "it adjudicates all claims" do
          providers = [Adjudication::Providers::Provider.new("1811052616")]
          expect(provider_manager).to receive(:retrieve_providers)
          expect(provider_manager).to receive(:providers).and_return(providers)

          claim = instance_double("Claim")
          expect(adjudicator).to receive(:adjudicate).with(claims_data[0], providers).and_return(claim)

          processed_claims = adjudication_engine.process(claims_data)
          expect(processed_claims[0]).to eq(claim)
        end
      end
    end

    context "when no providers are available" do
      it "it does not process any claims" do
        providers = []
        expect(provider_manager).to receive(:retrieve_providers)
        expect(provider_manager).to receive(:providers).and_return(providers)

        processed_claims = adjudication_engine.process(claims_data)
        expect(processed_claims.empty?).to eq(true)
      end
    end
  end
end
