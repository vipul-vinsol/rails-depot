# TODO Please follow 2 space indentation and remove white spaces.
# TODO Please follow Association, Callback, Validations, Scopes/ Delegations Order in models

class Category < ApplicationRecord
  validates :title, presence: true
  #TODO Why title?
  validates :title, uniqueness: {scope: :parent}, allow_blank: true, if: :title?

  #TODO Why is the method name starting from ensure. Are you ensuring something or you're validating.
  #TODO Please check how with_options work
  validate :ensure_parent_id_exists
  validate :ensure_parent_is_not_sub_category

  has_many :sub_categories, class_name: 'Category', dependent: :destroy, foreign_key: 'parent_id' 
  #TODO How is this working?
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
        #TODO Optimise this.
        unless Category.find(parent_id).parent_id?
          error.add(:parent_id, "subcategories can't have category")
        end
      end
    end
end
