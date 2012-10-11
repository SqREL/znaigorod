
class AddRatingToOrganizations < ActiveRecord::Migration
  def up
    require 'progress_bar'
    add_column :organizations, :rating, :float
    bar = ProgressBar.new(Organization.count)
    Organization.find_each { |o| o.save!; bar.increment! }
  end

  def down
    remove_column :organizations, :rating
  end
end
