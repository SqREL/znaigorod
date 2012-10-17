class CreateSaunas < ActiveRecord::Migration
  def change
    create_table :saunas do |t|
      t.references :organization

      t.timestamps
    end
    add_index :saunas, :organization_id
  end
end
