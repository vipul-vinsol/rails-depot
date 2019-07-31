class Cart < ApplicationRecord

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  def update_product_in_cart(product)
    if current_item = line_items.find_by(product_id: product.id)
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
      current_item.price = current_item.product.price
    end
    current_item
  end

  def total_price
    line_items.sum { |item| item.total_price }
  end
end