class NullFalseConstraintOnEnabledInProduct < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :products, :enabled, false
  end
end
