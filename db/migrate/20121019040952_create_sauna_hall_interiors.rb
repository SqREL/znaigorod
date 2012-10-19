class CreateSaunaHallInteriors < ActiveRecord::Migration
  def change
    create_table :sauna_hall_interiors do |t|
      t.references :sauna_hall
      t.integer :floors
      t.integer :lounges

      t.timestamps
    end
    add_index :sauna_hall_interiors, :sauna_hall_id
  end
end
