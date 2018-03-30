require "spec_helper"

RSpec.describe Adjudication::Providers::Fetcher do

  describe "retrieving provider data" do
    context"when pulling the data remotely" do
      let(:arbitrary_url) {"arbitrary url"}
      let(:fetcher) {Adjudication::Providers::Fetcher.new(arbitrary_url)}

      it "parses the providers CSV file" do
        path = File.expand_path(File.join("spec", "fixtures", 'beam-network.csv'))
        network_data = File.read(path)
        expect(fetcher).to receive(:open).with(arbitrary_url).and_return(network_data)

        providers = fetcher.provider_data

        expect(providers.length).to eq(8)
        expect(providers[0].npi).to eq("1073702056")
      end
    end
  end
end