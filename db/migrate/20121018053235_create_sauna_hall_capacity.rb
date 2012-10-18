class CreateSaunaHallCapacity < ActiveRecord::Migration
  def change
    create_table :sauna_hall_capacities do |t|
      t.references :sauna_hall
      t.integer :default
      t.integer :maximal
      t.integer :extra_guest_cost
      t.timestamps
    end
  end
end
