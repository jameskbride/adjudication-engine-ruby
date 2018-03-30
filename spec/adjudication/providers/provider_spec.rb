require "spec_helper"

RSpec.describe Adjudication::Providers::ProviderManager do

  describe "retrieving providers" do

    context "when retrieving providers remotely" do
      let(:fetcher) { instance_double("Fetcher") }
      let(:provider_manager) { Adjudication::Providers::ProviderManager.new(fetcher)}

      it "it includes valid providers" do
        good_provider = Adjudication::Providers::Provider.new("0123456789")
        expect(fetcher).to receive(:provider_data).and_return([good_provider])

        providers = provider_manager.retrieve_providers

        expect(providers).to eq([good_provider])
      end
    end
  end
end