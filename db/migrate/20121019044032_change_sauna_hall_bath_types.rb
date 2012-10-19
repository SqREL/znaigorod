class ChangeSaunaHallBathTypes < ActiveRecord::Migration
  def up
    drop_table :sauna_hall_baths
    create_table :sauna_hall_baths do |t|
      t.references :sauna_hall
      t.boolean :russian
      t.boolean :finnish
      t.boolean :turkish
      t.boolean :japanese
      t.boolean :infrared

      t.timestamps
    end
    add_index :sauna_hall_baths, :sauna_hall_id
  end

  def down
    drop_table :sauna_hall_baths
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
