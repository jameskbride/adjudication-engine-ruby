require "spec_helper"

RSpec.describe Adjudication::Providers do

  describe Adjudication::Providers::Provider do

    context "it is valid" do

      let(:provider) { Adjudication::Providers::Provider.new("0123456789")}

      it "when the npi is a 10 digit numeric value" do
        expect(provider.is_valid?).to eq(true)
      end
    end

    context "it is not valid" do

      it "when the npi is not numeric" do
        provider = Adjudication::Providers::Provider.new("a123456789")
        expect(provider.is_valid?).to eq(false)
      end

      it "when the npi too short" do
        provider = Adjudication::Providers::Provider.new("123456789")
        expect(provider.is_valid?).to eq(false)
      end

      it "when the npi too long" do
        provider = Adjudication::Providers::Provider.new("01234567890")
        expect(provider.is_valid?).to eq(false)
      end

      it "when the npi is nil" do
        provider = Adjudication::Providers::Provider.new(nil)
        expect(provider.is_valid?).to eq(false)
      end
    end
  end

  describe Adjudication::Providers::ProviderManager do

    describe "retrieving providers" do

    context "when retrieving providers remotely" do
      let(:fetcher) { instance_double("Fetcher") }
      let(:provider_manager) { Adjudication::Providers::ProviderManager.new(fetcher)}

      it "it includes valid providers" do
        good_provider = Adjudication::Providers::Provider.new("0123456789")
        expect(fetcher).to receive(:provider_data).and_return([good_provider])

        provider_manager.retrieve_providers
        providers = provider_manager.providers
        expect(providers).to eq([good_provider])
      end

      it "excludes invalid providers" do
        good_provider = Adjudication::Providers::Provider.new("0123456789")
        bad_provider = Adjudication::Providers::Provider.new("a123456789")
        expect(fetcher).to receive(:provider_data).and_return([good_provider, bad_provider])

        provider_manager.retrieve_providers
        providers = provider_manager.providers
        expect(providers).to eq([good_provider])
      end

      it "logs invalid providers to stderr" do
        invalid_npi = "a123456789"
        good_provider = Adjudication::Providers::Provider.new("0123456789")
        bad_provider = Adjudication::Providers::Provider.new(invalid_npi)
        expect(fetcher).to receive(:provider_data).and_return([good_provider, bad_provider])

        expect{provider_manager.retrieve_providers}.to output("Invalid provider: #{invalid_npi}\n").to_stderr
      end
    end
  end
  end
end