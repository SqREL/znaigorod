class CreateSaunaHallPools < ActiveRecord::Migration
  def change
    create_table :sauna_hall_pools do |t|
      t.references :sauna_hall
      t.string :size
      t.integer :contraflow
      t.integer :geyser
      t.integer :waterfall
      t.string :water_filter

      t.timestamps
    end
    add_index :sauna_hall_pools, :sauna_hall_id
  end
end
