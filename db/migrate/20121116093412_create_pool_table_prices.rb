class CreatePoolTablePrices < ActiveRecord::Migration
  def change
    create_table :pool_table_prices do |t|
      t.references :pool_table
      t.integer :day
      t.time :from
      t.time :to
      t.integer :price

      t.timestamps
    end
    add_index :pool_table_prices, :pool_table_id
  end
end
