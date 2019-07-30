class RemoveForeignKeyFromCategory < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :category, 'parent_category_id'
  end
end
