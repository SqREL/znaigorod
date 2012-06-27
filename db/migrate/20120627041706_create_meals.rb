class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.text :category
      t.text :feature
      t.text :offer
      t.string :payment
      t.text :cuisine
      t.references :organization

      t.timestamps
    end
    add_index :meals, :organization_id
  end
end
