require "adjudication/engine/version"
require "adjudication/claims/adjudicator"
require "adjudication/providers/fetcher"
require "adjudication/providers/providers"

module Adjudication
  module Engine
    def self.run(claims_data)
      provider_data_uri = 'http://provider-data.beam.dental/beam-network.csv'
      fetcher = Adjudication::Providers::Fetcher.new(provider_data_uri)
      adjudicator = Adjudication::Claims::Adjudicator.new
      provider_manager = Adjudication::Providers::ProviderManager.new(fetcher)
      adjudication_engine = Adjudication::Engine::AdjudicationEngine.new(adjudicator, provider_manager)
      adjudication_engine.process(claims_data)
    end

    class AdjudicationEngine

      def initialize(adjudicator, provider_manager)
        @adjudicator = adjudicator
        @provider_manager = provider_manager
      end

      def process(claims_data)
        preprocessed_claims_data = preprocess_claims(claims_data)
        @provider_manager.retrieve_providers
        providers = @provider_manager.providers
        preprocessed_claims_data.map {|claim| @adjudicator.adjudicate(claim, providers)}
      end

      private
      def preprocess_claims(claims_data)
        claims_data.map {|data|
          data_with_provider = data
          data_with_provider['provider'] = data['npi']

          data_with_provider
        }
      end
    end
  end
end
