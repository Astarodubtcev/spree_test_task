# frozen_string_literal: true

class ProductsImportService
  WrongUploadState = Class.new(StandardError)

  def initialize(product_upload)
    @product_upload = product_upload
  end

  def import_products
    raise WrongUploadState unless product_upload.importing?

    if import_provider.import
      product_upload.finish
    else
      product_upload.fail
    end

    update_upload_stats(import_provider.imported_products)
  end

  private

  attr_reader :product_upload

  def import_provider
    @import_provider ||= ProviderSelector.provider(product_upload.upload_type).new(product_upload)
  end

  def update_upload_stats(imported_products)
    product_upload.update(imported_products: imported_products)
  end
end
