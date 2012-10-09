class AddTourLinkToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :tour_link, :text
  end
end
