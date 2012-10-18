class CreateSaunaChildStuffs < ActiveRecord::Migration
  def change
    create_table :sauna_child_stuffs do |t|
      t.references :sauna
      t.integer :life_jacket
      t.integer :cartoons
      t.integer :games
      t.integer :rubber_ring

      t.timestamps
    end
    add_index :sauna_child_stuffs, :sauna_id
  end
end
