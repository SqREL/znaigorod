class CreatePostImages < ActiveRecord::Migration
  def change
    create_table :post_images do |t|
      t.string :title
      t.references :post

      t.timestamps
    end
    add_index :post_images, :post_id
  end
end
