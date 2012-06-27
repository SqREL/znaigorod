class CreateEntertainments < ActiveRecord::Migration
  def change
    create_table :entertainments do |t|
      t.text :category
      t.text :feature
      t.text :offer
      t.string :payment
      t.references :organization

      t.timestamps
    end
    add_index :entertainments, :organization_id
  end
end
