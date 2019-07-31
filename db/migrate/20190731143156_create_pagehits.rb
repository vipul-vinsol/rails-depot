class CreatePagehits < ActiveRecord::Migration[5.2]
  def change
    create_table :pagehits do |t|
      t.string :page
      t.integer :count, default: 0

      t.timestamps
    end
    add_index :pagehits, :page
  end
end
