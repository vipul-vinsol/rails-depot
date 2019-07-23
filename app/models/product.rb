require 'active_model/serializers/xml'
class Product < ApplicationRecord

  IMAGE_URL_ENDS_WITH_ALLOWED_FILE_FORMATS_REGEX = %r{\.(gif|jpg|png)\z}i
  PERMALINK_FORMAT_REGEX = %r{\A[a-zA-Z0-9\-]+\z}

  include ActiveModel::Serializers::Xml
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :permalink, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, if: :price?
  validates :title, uniqueness: true, length: {minimum: 10}
  
  validates :image_url, allow_blank: true, format: {
    with: IMAGE_URL_ENDS_WITH_ALLOWED_FILE_FORMATS_REGEX,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  
  validates :permalink, allow_nil: true, uniqueness: true, format: {
    with: PERMALINK_FORMAT_REGEX,
    message: 'Invalid format'
  }
  
  validates_each :permalink do |record, attr, value|
    record.errors.add(attr, 'Invalid format') if value && value.split('-').length < 3 
  end

  validates_each :description do |record, attr, value|
    record.errors.add(attr, 'Should be between 5 to 10 words') if value && value.split.length.between?(5, 10)
  end
  
  # Without Custom Method
  validates :discount_price, numericality: { less_than: :price }
  
  # Custom Method
  # validate :discount_cannot_be_greater_than_total_value

  private
    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

    def discount_cannot_be_greater_than_total_value
      if discount_price > price
        errors.add(:discount_price, "can't be greater than total value")
      end
    end
end
