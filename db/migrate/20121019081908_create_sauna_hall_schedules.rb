class CreateSaunaHallSchedules < ActiveRecord::Migration
  def change
    create_table :sauna_hall_schedules do |t|
      t.references :sauna_hall
      t.integer :day
      t.time :from
      t.time :to
      t.integer :price

      t.timestamps
    end
    add_index :sauna_hall_schedules, :sauna_hall_id
  end
end
