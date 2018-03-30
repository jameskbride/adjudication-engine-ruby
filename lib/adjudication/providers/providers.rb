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
      def initialize(fetcher)
        @fetcher = fetcher
      end

      def retrieve_providers
        providers = @fetcher.provider_data
        providers.select {|provider| provider.is_valid?}
      end

    end
  end
end
