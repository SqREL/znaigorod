class ChangeImage < ActiveRecord::Migration
  def up
    rename_column :images, :organization_id, :imageable_id
    add_column :images, :imageable_type, :string
  end

  def down
    remove_column :images, :imageable_type
    rename_column :images, :imageable_id , :organization_id
  end
end
