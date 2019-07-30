class Category < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: {scope: :parent}, allow_blank: true, if: :title?
  validate :ensure_parent_id_exists
  validate :ensure_parent_is_not_sub_category

  has_many :sub_categories, class_name: 'Category', dependent: :destroy, foreign_key: 'parent_id' 
  belongs_to :parent, class_name: "Employee", optional: true
  has_many :products, dependent: :restrict_with_error
  has_many :sub_categories_products, through: :sub_categories, source: :products

  private 

    def ensure_parent_id_exists
      if parent_id?
        unless Category.exists?(parent_id)
          error.add(:parent_id, "No such parent Category exists")
        end
      end
    end

    def ensure_parent_is_not_a_sub_category
      if parent_id?
        unless Category.find(parent_id).parent_id?
          error.add(:parent_id, "subcategories can't have category")
        end
      end
    end

end