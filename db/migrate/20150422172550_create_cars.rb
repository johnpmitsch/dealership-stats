class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :year
      t.string :make
      t.string :model
      t.date :date_sold
      t.float :price

      t.timestamps null: false
    end
  end
end
