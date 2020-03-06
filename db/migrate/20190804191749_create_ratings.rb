class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.decimal :value, precision: 2, scale: 1
      t.references :prodcut
      t.references :user

      t.timestamps
    end
  end
end
