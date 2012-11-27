class AddAdditionalRatingToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :additional_rating, :integer
  end
end
