class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, counter_cache: true

  validates_uniqueness_of :cart_id, scope: :product_id

  def total_price
    product.price * quantity
  end
end
