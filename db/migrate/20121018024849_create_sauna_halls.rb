class CreateSaunaHalls < ActiveRecord::Migration
  def change
    create_table :sauna_halls do |t|
      t.references :sauna
      t.string :title

      t.timestamps
    end
    add_index :sauna_halls, :sauna_id
  end
end
