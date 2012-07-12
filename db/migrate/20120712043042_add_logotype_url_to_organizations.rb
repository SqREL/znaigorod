class AddLogotypeUrlToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :logotype_url, :text
  end
end
