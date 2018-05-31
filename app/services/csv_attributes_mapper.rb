# frozen_string_literal: true

class CsvAttributesMapper
  extend HashMapper

  def self.to_internal(raw_attributes)
    normalize(raw_attributes.with_indifferent_access)
  end

  DEFAULTS = {
    taxonomy: { name: 'Category' }
  }.freeze

  # Adding defaults to mapped attributes
  after_normalize do |_, output|
    output[:product][:price] = output[:product][:price].tr(',', '.')
    output.deep_merge(DEFAULTS).with_indifferent_access
  end

  map from('/name'),              to('/product/name')
  map from('/description'),       to('/product/description')
  map from('/price'),             to('/product/price')
  map from('/availability_date'), to('/product/available_on')
  map from('/slug'),              to('/product/slug')
  map from('/stock_total'),       to('/stock_item/count_on_hand')
  map from('/category'),          to('/taxon/name')
end
