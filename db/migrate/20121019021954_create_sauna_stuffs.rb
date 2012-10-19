class CreateSaunaStuffs < ActiveRecord::Migration
  def change
    create_table :sauna_stuffs do |t|
      t.references :sauna
      t.integer :wifi
      t.integer :safe

      t.timestamps
    end
    add_index :sauna_stuffs, :sauna_id
  end
end
