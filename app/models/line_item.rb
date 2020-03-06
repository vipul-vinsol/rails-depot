class LineItem < ApplicationRecord
  with_options optional: true do |assoc|
    assoc.belongs_to :order
    assoc.belongs_to :product
  end
  belongs_to :cart, counter_cache: true

  validates :cart_id, uniqueness: { scope: :product_id }, allow_nil: true

  delegate :total_price, to: :cart

  def total_price
    product.price * quantity
  end
end
