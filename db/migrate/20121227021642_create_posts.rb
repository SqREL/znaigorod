class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.text :annotation
      t.text :content
      t.text :poster_url
      t.string :vfs_path
      t.string :slug

      t.timestamps
    end
  end
end
