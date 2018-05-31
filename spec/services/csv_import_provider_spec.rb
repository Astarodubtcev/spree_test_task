# frozen_string_literal: true

RSpec.describe CsvImportProvider do
  describe '#import' do
    subject { import_provider.import }

    let(:import_provider) { described_class.new(product_upload) }
    let(:product_upload)  { create :product_upload }

    it { is_expected.to be_truthy }

    it 'creates 3 products' do
      expect { subject }.to change { Spree::Product.count }.by(3)
    end
  end
end
