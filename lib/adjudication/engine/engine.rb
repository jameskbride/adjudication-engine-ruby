require "adjudication/engine/version"
require "adjudication/claims/adjudicator"
require "adjudication/claims/claim"

module Adjudication
  module Engine
    def self.run(claims_data, fetcher)
      provider_data = fetcher.provider_data

      # TODO filter resulting provider data, match it up to claims data by
      # provider NPI (national provider ID), and run the adjudicator.
      # This method should return the processed claims

      []
    end

    class AdjudicationEngine

      def initialize(adjudicator)
        @adjudicator = adjudicator
      end

      def process(claims_data)
        preprocessed_claims_data = preprocess_claims(claims_data)
        preprocessed_claims_data.map {|claim| @adjudicator.adjudicate(claim)}
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
