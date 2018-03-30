require "adjudication/providers/fetcher"

module Adjudication
  module Providers
    class Provider
      def initialize(npi)

      end
    end

    class ProviderManager
      def initialize(fetcher)
        @fetcher = fetcher
      end

      def retrieve_providers
        @fetcher.provider_data
      end

    end
  end
end
