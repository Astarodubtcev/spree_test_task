# frozen_string_literal: true

class AddProductUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_product_uploads do |t|
      t.string :state
      t.string :upload_type
      t.has_attached_file :file
      t.integer :imported_products, default: 0

      t.timestamps
    end
  end
end
