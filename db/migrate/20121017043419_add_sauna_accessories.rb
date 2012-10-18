class AddSaunaAccessories < ActiveRecord::Migration
  def change
    create_table :sauna_accessories do |t|
      t.references :sauna
      t.integer :sheets
      t.integer :sneakers
      t.integer :bathrobes
      t.integer :towels
      t.integer :brooms
      t.integer :oils

      t.timestamps
    end

    add_index :sauna_accessories, :sauna_id
  end
end
