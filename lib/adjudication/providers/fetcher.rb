require "open-uri"
require "csv"

module Adjudication
  module Providers
    class Fetcher

      def initialize(provider_data_uri)
        @data_uri = provider_data_uri
      end

      def provider_data
        CSV.new(open(@data_uri), {:headers => :first_row}).map do |csv|
          Adjudication::Providers::Provider.new(csv['NPI'])
        end
      end
    end
  end
end
