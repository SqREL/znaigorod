class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.text :image_url
      t.string :author_info
      t.references :contest
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :works, :contest_id
  end
end
