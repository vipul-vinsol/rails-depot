require 'active_model/serializers/xml'
class Product < ApplicationRecord
  include ActiveModel::Serializers::Xml
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, if: Proc.new { |p| p.price.present? }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true

  validates :title, length: {minimum: 10}

  validates :permalink, uniqueness: true, format: {
    with: %r{\A[a-zA-Z0-9\-]+\z},
    message: 'Invalid format'
  }

  validates_each :permalink do |record, attr, value|
    record.errors.add(attr, 'Invalid format') if value.split('-').length < 3
  end

  validates_each :description do |record, attr, value|
    record.errors.add(attr, 'Should be between 5 to 10 words') if value.split.length.between?(5, 10)
  end

  # without Custom Method
  validates :discount_pirce, numericality: { less_than: :price }

  # Custom Method
  # validate :discount_cannot_be_greater_than_total_value

  def discount_cannot_be_greater_than_total_value
    if discount_pirce > price
      errors.add(:discount_pirce, "can't be greater than total value")
    end
  end

  private

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :aboseptemberrt
      end
    end
end
