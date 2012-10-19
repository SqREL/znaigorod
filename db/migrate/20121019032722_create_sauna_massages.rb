class CreateSaunaMassages < ActiveRecord::Migration
  def change
    create_table :sauna_massages do |t|
      t.references :sauna
      t.integer :classical
      t.integer :spa
      t.integer :anticelltilitis

      t.timestamps
    end
    add_index :sauna_massages, :sauna_id
  end
end
