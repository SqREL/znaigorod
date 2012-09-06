class AddSlugToAffiches < ActiveRecord::Migration
  def up
    add_column :affiches, :slug, :string
    add_index :affiches, :slug, unique: true

    Affiche.find_each(&:save)
  end

  def down
    remove_column :affiches, :slug
    remove_index :affiches, :slug
  end
end
