class AddVfsPathToSaunaHalls < ActiveRecord::Migration
  def change
    add_column :sauna_halls, :vfs_path, :text
  end
end
