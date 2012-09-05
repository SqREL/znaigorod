class AddDistributionDatesToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :distribution_starts_on, :datetime
    add_column :affiches, :distribution_ends_on, :datetime
  end
end
