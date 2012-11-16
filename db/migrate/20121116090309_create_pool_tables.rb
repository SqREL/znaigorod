class CreatePoolTables < ActiveRecord::Migration
  def change
    create_table :pool_tables do |t|
      t.integer :size
      t.integer :count
      t.string :kind
      t.references :billiard

      t.timestamps
    end
    add_index :pool_tables, :billiard_id
  end
end
