class ChangeSaunaHallWaterAccessoryFieldTypes < ActiveRecord::Migration
  def up
    drop_table :sauna_hall_water_accessories

    create_table :sauna_hall_water_accessories do |t|
      t.references :sauna_hall
      t.boolean :jacuzzi
      t.boolean :bucket

      t.timestamps
    end
    add_index :sauna_hall_water_accessories, :sauna_hall_id
  end

  def down
    drop_table :sauna_hall_water_accessories

    create_table :sauna_hall_water_accessories do |t|
      t.references :sauna_hall
      t.integer :jacuzzi
      t.integer :bucket

      t.timestamps
    end
    add_index :sauna_hall_water_accessories, :sauna_hall_id
  end
end
