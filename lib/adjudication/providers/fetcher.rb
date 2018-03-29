module Adjudication
  module Providers
    class Fetcher

      def initialize(provider_data_uri)
        @data_uri = provider_data_uri
      end

      def provider_data
        # TODO Import CSV data from http://provider-data.beam.dental/beam-network.csv
        # and return it.
      end
    end
  end
end
