# frozen_string_literal: true

module Spree
  class ProductUpload < ApplicationRecord
    has_attached_file(
      :file,
      url: '/spree/products/uploads/:basename.:extension',
      path: ':rails_root/public/spree/products/uploads/:basename.:extension'
    )

    validates_attachment(:file, presence: true, content_type: { content_type: 'text/plain' })

    validates_presence_of :upload_type

    state_machine :state, initial: :initialized do
      event :import do
        transition from: :initialized, to: :importing
      end

      event :finish do
        transition from: :importing, to: :finished
      end

      event :fail do
        transition from: :importing, to: :failed
      end
    end
  end
end
