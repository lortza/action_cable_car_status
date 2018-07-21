class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.string :make
      t.string :model
      t.references :color, foreign_key: true
      t.references :status, foreign_key: true

      t.timestamps
    end
  end
end
