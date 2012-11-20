class AddFieldsToSaunas < ActiveRecord::Migration
  def up
    remove_column :sauna_accessories, :title
    remove_column :sauna_accessories, :description
  end

  def down
    add_column :sauna_accessories, :description, :text
    add_column :sauna_accessories, :title, :string
  end
end
