# TODO Please follow 2 space indentation and remove white spaces.
class Cart < ApplicationRecord

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  #TODO Why do we need a association here. Even if it's needed please move the condition to scope
  has_many :enabled_products, -> { where enabled: true }, through: :line_items, source: :product 

  #TODO Refactor this method. The name suggests that it's just adding a product.
  def add_product(product)
    if current_item = line_items.find_by(product_id: product.id)
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
      #TODO Please use delegate
      current_item.price = current_item.product.price
    end
    current_item
  end

  def total_price
    #TODO Why do you need to_a here. Please check if you have a better enumerator available
    line_items.to_a.sum { |item| item.total_price }
  end
end
