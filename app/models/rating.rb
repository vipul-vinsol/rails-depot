class Rating < ApplicationRecord
  validates :user_id, uniqueness: { scope: :product_id, message: 'can only rate a product once' }
  
  private
    def add_assosciated_product_id(product_id)
      self.product_id = product_id
    end

    def add_logged_in_user_id(user_id)
      self.user_id = user_id
    end
end