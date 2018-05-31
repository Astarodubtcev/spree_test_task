# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsImportWorker do
  describe '#perform' do
    subject { described_class.new.perform(product_upload.id) }

    let(:product_upload) { create :product_upload }
    let(:import_service) { double 'import service' }

    before { allow(ProductsImportService).to receive(:new) { import_service } }
    before { allow(import_service).to receive(:import_products) {} }

    it 'changes state of upload' do
      expect { subject }.to change { product_upload.reload.state }.from('initialized').to('importing')
    end

    it 'invokes product import service' do
      expect(import_service).to receive(:import_products)
      subject
    end
  end
end
