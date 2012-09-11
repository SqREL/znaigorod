class CreateCultures < ActiveRecord::Migration
  def change
    create_table :cultures do |t|
      t.text :category
      t.text :feature
      t.text :offer
      t.string :payment
      t.integer :organization_id

      t.timestamps
    end
  end
end
