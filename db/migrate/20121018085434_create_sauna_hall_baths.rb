class CreateSaunaHallBaths < ActiveRecord::Migration
  def change
    create_table :sauna_hall_baths do |t|
      t.references :sauna_hall
      t.integer :russian
      t.integer :finnish
      t.integer :turkish
      t.integer :japanese
      t.integer :infrared

      t.timestamps
    end
    add_index :sauna_hall_baths, :sauna_hall_id
  end
end
