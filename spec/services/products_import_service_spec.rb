# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsImportService do
  describe '#import_products' do
    subject { import_service.import_products }

    let(:import_service) { described_class.new(product_upload) }
    let(:product_upload) { create :product_upload }

    it 'raises error' do
      expect { subject }.to raise_error(ProductsImportService::WrongUploadState)
    end

    context 'with product upload in importing state' do
      let(:product_upload)  { create :product_upload, state: 'importing' }
      let(:import_provider) { double 'import provider' }

      before { allow(import_service).to receive(:import_provider) { import_provider } }
      before { allow(import_provider).to receive(:import) { true } }
      before { allow(import_provider).to receive(:imported_products) { 1 } }

      it 'starts import' do
        expect(import_provider).to receive(:import)
        subject
      end

      it 'changes product upload status' do
        expect { subject }.to change { product_upload.state }.from('importing').to('finished')
      end

      it 'increments the imported products' do
        expect { subject }.to change { product_upload.imported_products }.by(1)
      end

      context 'when import fails' do
        before { allow(import_provider).to receive(:import) { false } }

        it 'changes product upload status' do
          expect { subject }.to change { product_upload.state }.from('importing').to('failed')
        end
      end
    end
  end
end
