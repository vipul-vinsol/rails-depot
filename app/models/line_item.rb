class LineItem < ApplicationRecord
  #TODO Please use with_options
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, counter_cache: true

  #TODO Please use new syntax and why cart_id and why is allow_nil missing here?
  validates_uniqueness_of :cart_id, scope: :product_id

  def total_price
    #TODO Use delegate here
    product.price * quantity
  end
end
