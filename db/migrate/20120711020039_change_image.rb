class ChangeImage < ActiveRecord::Migration
  def up
    remove_column :images, :organization_id
    add_column :images, :imageable_type, :string
    add_column :images, :imageable_id, :integer
  end

  def down
    remove_column :images, :imageable_id
    remove_column :images, :imageable_type
    add_column :images, :organization_id, :integer
  end
end
