class AddDiscountPriceToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :discount_pirce, :decimal
  end
end
