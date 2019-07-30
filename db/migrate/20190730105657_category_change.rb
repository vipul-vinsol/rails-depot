class CategoryChange < ActiveRecord::Migration[5.1]
  def change
    remove_index 'categories', name: "index_categories_on_parent_category_id"
    remove_column 'categories', 'parent_category_id'
  end
end
