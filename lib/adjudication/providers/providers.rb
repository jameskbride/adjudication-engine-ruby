require "adjudication/providers/fetcher"

module Adjudication
  module Providers
    class Provider
      def initialize(npi)
        @npi = npi
      end

      def is_valid?
        !!/^\d{10}$/.match(@npi)
      end
    end

    class ProviderManager

      attr_accessor(:providers)

      def initialize(fetcher)
        @fetcher = fetcher
        @providers = []
      end

      def retrieve_providers
        providers = @fetcher.provider_data
        @providers = providers.select {|provider| provider.is_valid?}
      end

    end
  end
end
