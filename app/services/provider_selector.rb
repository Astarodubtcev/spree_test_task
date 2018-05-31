# frozen_string_literal: true

class ProviderSelector
  UnknownProviderError = Class.new(StandardError)

  PROVIDERS = {
    csv: CsvImportProvider
  }.freeze

  def self.provider(provider_type)
    provider = PROVIDERS[provider_type.to_sym]

    raise UnknownProviderError unless provider

    provider
  end
end
