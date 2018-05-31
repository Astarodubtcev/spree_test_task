# frozen_string_literal: true

class ProductsImportWorker
  include Sidekiq::Worker

  def perform(upload_id)
    product_upload = Spree::ProductUpload.find(upload_id)

    return unless product_upload

    product_upload.import
    import_service(product_upload).import_products
  end

  private

  def import_service(product_upload)
    ProductsImportService.new(product_upload)
  end
end
