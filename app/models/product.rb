require 'active_model/serializers/xml'
class Product < ApplicationRecord

  IMAGE_URL_ENDS_WITH_ALLOWED_FILE_FORMATS_REGEX = %r{\.(gif|jpg|png)\z}i
  PERMALINK_FORMAT_REGEX = %r{\A[a-zA-Z0-9\-]+\z}

  include ActiveModel::Serializers::Xml

  scope :enabled, -> { where enabled: true }

  has_many :carts, through: :line_items
  has_many :line_items, dependent: :restrict_with_exception
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  before_validation :set_conditional_defaults
  
  validates :title, :description, :image_url, :permalink, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, if: :price?
  validates :title, uniqueness: true, length: {minimum: 10}

  validates :image_url, allow_blank: true, format: {
    with: IMAGE_URL_ENDS_WITH_ALLOWED_FILE_FORMATS_REGEX,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  
  validates :permalink, allow_blank: true, uniqueness: true, format: {
    with: PERMALINK_FORMAT_REGEX,
    message: 'Invalid format'
  }
  
  validates_each :permalink do |record, attr, value|
    record.errors.add(attr, 'Invalid format') if value.present? && value.split('-').length < 3 
  end

  validates_each :description do |record, attr, value|
    if value.present? && !value.split.length.between?(5, 10)
      record.errors.add(attr, 'Should be between 5 to 10 words')
    end
  end
    
  # Without Custom Method
  validates :discount_price, allow_blank: true, numericality: { less_than_equal: :price }
  
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
      if discount_price >= price
        errors.add(:discount_price, "can't be greater than total value")
      end
    end

    def set_conditional_defaults
      self.title = 'abc' if title.blank?
      self.discount_price = price if discount_price.blank?
    end
end
45.0