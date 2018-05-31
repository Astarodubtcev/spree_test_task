# frozen_string_literal: true

FactoryBot.define do
  factory :product_upload, class: Spree::ProductUpload do
    file        { File.new("#{Rails.root}/sample.csv") }
    upload_type 'csv'
  end
end
