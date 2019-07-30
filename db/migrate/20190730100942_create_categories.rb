class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.references :parent_category, foreign_key: true
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
