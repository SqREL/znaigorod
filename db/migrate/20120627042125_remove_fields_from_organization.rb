class RemoveFieldsFromOrganization < ActiveRecord::Migration
  def up
    remove_column :organizations, :categories
    remove_column :organizations, :cuisine
    remove_column :organizations, :feature
    remove_column :organizations, :offer
    remove_column :organizations, :payment
    remove_column :organizations, :type
  end

  def down
    add_column :organizations, :payment, :text
    add_column :organizations, :type, :string
    add_column :organizations, :feature, :text
    add_column :organizations, :offer, :text
    add_column :organizations, :cuisine, :text
    add_column :organizations, :categories, :text
  end
end
