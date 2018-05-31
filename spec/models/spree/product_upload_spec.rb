# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::ProductUpload, type: :model do
  it { should have_attached_file(:file) }
  it { should validate_attachment_content_type(:file).allowing('text/plain') }
  it { should validate_presence_of(:upload_type) }
end
