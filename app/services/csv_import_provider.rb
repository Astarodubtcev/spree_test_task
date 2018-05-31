# frozen_string_literal: true

require 'csv'
require 'byebug'

class CsvImportProvider
  attr_reader :imported_products

  DEFAULTS = {
    headers: true,
    col_sep: ';'
  }.freeze

  def initialize(product_upload, options = {})
    @file_path         = product_upload.file.path
    @options           = options.merge(DEFAULTS)
    @imported_products = 0
  end

  def import
    CSV.foreach(file_path, options) do |row|
      row_hash = row.to_hash
      next if row_hash.values.all?(&:nil?)

      mapped_attributes = map_attributes(row_hash)

      taxonomy = find_or_create_taxonomy(mapped_attributes[:taxonomy])
      taxon    = taxonomy.taxons.find_or_create_by(mapped_attributes[:taxon])
      product  = create_product(mapped_attributes[:product], taxon)

      add_stock(product.master, mapped_attributes[:stock_item])
    end

    true
  rescue StandardError
    false
  end

  private

  attr_reader :file_path, :options, :product_upload

  def map_attributes(raw_attributes)
    CsvAttributesMapper.to_internal(raw_attributes)
  end

  def find_or_create_taxonomy(taxonomy_attributes)
    Spree::Taxonomy.find_or_create_by(taxonomy_attributes)
  end

  def find_or_create_taxon(taxon_attributes, taxonomy)
    Spree::Taxon.find_or_create_by(taxon_attributes.merge(taxonomy: taxonomy))
  end

  def create_product(product_attributes, taxon)
    product = Spree::Product.find_or_initialize_by(product_attributes.except(:price))

    return product if product.persisted?

    product.taxons << taxon
    product.price = product_attributes[:price]
    product.shipping_category = default_shipping_category
    @imported_products += 1
    product.save
    product
  end

  def add_stock(variant, stock_item_attributes)
    stock_item = variant.stock_items.first_or_create(location: default_location)
    stock_item.adjust_count_on_hand(stock_item_attributes[:count_on_hand].to_i)
  end

  def default_location
    Spree::StockLocation.find_or_create_by(name: 'default')
  end

  def default_shipping_category
    Spree::ShippingCategory.find_or_create_by(name: 'Default')
  end
end
