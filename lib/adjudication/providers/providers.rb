require "adjudication/providers/fetcher"

module Adjudication
  module Providers
    class Provider

      attr_accessor(:npi)

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
        @providers, invalid = @providers = providers.partition {|provider| provider.is_valid?}
        invalid.each {|provider| $stderr.puts("Invalid provider: #{provider.npi}")}
      end

    end
  end
end
