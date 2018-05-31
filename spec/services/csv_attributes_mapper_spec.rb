# frozen_string_literal: true

RSpec.describe CsvAttributesMapper do
  describe '.to_internal' do
    subject { described_class.to_internal(input_attributes) }

    let(:input_attributes) do
      {
        name:              'name',
        description:       'description',
        price:             '12,5',
        availability_date: 'date',
        slug:              'slug',
        stock_total:       '10',
        category:          'bags'
      }
    end

    let(:expected_attributes) do
      {
        product: {
          name:         'name',
          description:  'description',
          price:        '12.5',
          available_on: 'date',
          slug:         'slug'
        },
        taxonomy:   { name: 'Category' },
        taxon:      { name: 'bags' },
        stock_item: { count_on_hand: '10' }
      }.with_indifferent_access
    end

    it { is_expected.to eq(expected_attributes) }
  end
end
