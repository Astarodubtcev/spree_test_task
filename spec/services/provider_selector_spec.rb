# frozen_string_literal: true

RSpec.describe ProviderSelector do
  describe '.provider' do
    subject { described_class.provider(provider_type) }

    let(:provider_type) { 'csv' }

    it { is_expected.to eq(CsvImportProvider) }

    context 'with wrong provider type' do
      let(:provider_type) { 'wrong type' }

      it 'raises error' do
        expect { subject }.to raise_error(ProviderSelector::UnknownProviderError)
      end
    end
  end
end
