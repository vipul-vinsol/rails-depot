require 'active_model/serializers/xml'
class Product < ApplicationRecord
  include ActiveModel::Serializers::Xml

  IMAGE_URL_ENDS_WITH_ALLOWED_FILE_FORMATS_REGEX = %r{\.(gif|jpg|png)\z}i
  PERMALINK_REGEX = %r{\A[a-zA-Z0-9\-]+\z}

  validates :title, :description, :price, :image_url, :permalink, :category_id, presence: true
  validates :price, numericality: { greater_than: 0 }, allow_blank: true
  validates :title, uniqueness: true, length: { minimum: 10 }, allow_blank: true
  validates :image_url, allow_blank: true, format: {
    with: IMAGE_URL_ENDS_WITH_ALLOWED_FILE_FORMATS_REGEX,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  validates :permalink, allow_blank: true, uniqueness: true, format: {
    with: PERMALINK_REGEX,
    message: 'Invalid format'
  }
  validate :description_should_be_between_five_to_ten_words
  validate :permalink_should_have_minimum_three_words_hypen_seprated
  # Without Custom Method
  validates :discount_price, allow_blank: true, numericality: { less_than_equal: :price }
  # Custom Method
  # validate :discount_cannot_be_greater_than_total_value
  validate :only_images_can_be_uploaded
  validate :no_more_than_three_images_can_be_uploaded
    
  before_validation :set_conditional_defaults
  after_create :increment_count
  
  belongs_to :category, counter_cache: :count
  has_many :carts, through: :line_items
  has_many :orders, through: :line_items
  has_many :ratings, dependent: :destroy
  has_many :line_items, dependent: :restrict_with_exception

  has_many_attached :product_images

  scope :enabled, -> { where enabled: true }
 
  private
    # ensure that there are no line items referencing this product
    # def not_referenced_by_any_line_item
    #   unless line_items.empty?
    #     errors.add(:base, 'Line Items present')
    #   end
    # end

    def discount_cannot_be_greater_than_total_value
      if discount_price >= price
        errors.add(:discount_price, "can't be greater than total value")
      end
    end

    def description_should_be_between_five_to_ten_words
      if description.present? && !description.split.length.between?(5, 10)
        errors.add(:description, "Description can only be between 5 to 10 words") 
      end
    end

    def permalink_should_have_minimum_three_words_hypen_seprated
      if permalink.present? && permalink.split('-').length < 3
        errors.add(:permalink, "Should have minimum three words hypen seprated")
      end
    end

    def set_conditional_defaults
      self.title = 'abc' if title.blank?
      self.discount_price = price if discount_price.blank?
    end

    def increment_count
      parent = category.parent_id
      if parent.present?
        Category.increment_counter(:count, parent)
      end
    end

    def only_images_can_be_uploaded
      product_images.each do |product_image|
        errors.add(:product_images, "Only Image files can be uploaded") unless product_image.image?
      end
    end
    
    def no_more_than_three_images_can_be_uploaded
      errors.add(:product_images, "no more than three images can be uploaded") if product_images.size > 3 
    end    
end

  