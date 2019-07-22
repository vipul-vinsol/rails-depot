class AddEnabledToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :enabled, :boolean
  end
end
