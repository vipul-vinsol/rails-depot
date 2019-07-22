class IrreversableMigration < ActiveRecord::Migration[5.1]
  def up
	# Any DB operation 
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end