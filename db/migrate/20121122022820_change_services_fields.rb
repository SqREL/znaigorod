class ChangeServicesFields < ActiveRecord::Migration
  def up
    add_column :services, :category, :text
    add_column :services, :description, :text
    remove_column :services, :offer
    remove_column :services, :tag
  end

  def down
    add_column :services, :tag, :text
    add_column :services, :offer, :text
    remove_column :services, :description
    remove_column :services, :category
  end
end
