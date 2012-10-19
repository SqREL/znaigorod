class CreateSaunaHallStuffs < ActiveRecord::Migration
  def change
    create_table :sauna_hall_stuffs do |t|
      t.references :sauna_hall
      t.integer :pit
      t.integer :pylon
      t.integer :barbecue

      t.timestamps
    end
    add_index :sauna_hall_stuffs, :sauna_hall_id
  end
end
