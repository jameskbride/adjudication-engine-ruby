require "open-uri"
require "csv"

module Adjudication
  module Providers
    class Fetcher

      def initialize(provider_data_uri)
        @data_uri = provider_data_uri
      end

      def provider_data
        providers = []
        CSV.new(open(@data_uri), {:headers => :first_row}).each do |csv|
          providers.push(Adjudication::Providers::Provider.new(csv['NPI']))
        end

        providers
      end
    end
  end
end
