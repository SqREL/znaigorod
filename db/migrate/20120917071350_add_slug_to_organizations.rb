class AddSlugToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :slug, :string
    add_index :organizations, :slug, unique: true

    bar = ProgressBar.new(Organization.count)
    Organization.all.each do |organization|
      organization.save
      bar.increment!
    end
  end

  def down
    remove_index :organizations, :slug
    remove_column :organizations, :slug
  end
end
