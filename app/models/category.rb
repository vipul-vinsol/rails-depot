class Category < ApplicationRecord
  
  validates :title, presence: true
  validates :title, uniqueness: {scope: :parent}, allow_blank: true
  validate :validate_parent_id_exists, if: :parent_id?
  validate :validate_parent_is_not_sub_category, if: :parent_id?

  belongs_to :parent, class_name: "Category", optional: true
  has_many :sub_categories, class_name: "Category", dependent: :destroy, foreign_key: "parent_id"
  has_many :products, dependent: :restrict_with_error
  has_many :sub_categories_products, through: :sub_categories, source: :products

  private

    def validate_parent_id_exists
      unless Category.exists?(parent_id)
        error.add(:parent_id, "No such parent Category exists")
      end
    end

    def validate_parent_is_not_a_sub_category
      unless parent.parent_id?
        error.add(:parent_id, "subcategories can't have category")
      end
    end
end
