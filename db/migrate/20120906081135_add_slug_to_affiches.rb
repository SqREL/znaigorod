class AddSlugToAffiches < ActiveRecord::Migration
  def up
    add_column :affiches, :slug, :string
    add_index :affiches, :slug, unique: true

    bar = ProgressBar.new(Affiche.count)
    Affiche.all.each do |affiche|
      affiche.save
      bar.increment!
    end
  end

  def down
    remove_index :affiches, :slug
    remove_column :affiches, :slug
  end
end
