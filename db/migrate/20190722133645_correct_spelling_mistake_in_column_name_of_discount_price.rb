class CorrectSpellingMistakeInColumnNameOfDiscountPrice < ActiveRecord::Migration[5.1]
  def change
  	rename_column :products, :discount_pirce, :discount_price
  end
end
