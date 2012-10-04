class AddVkAidToAffiche < ActiveRecord::Migration
  def change
    add_column :affiches, :vk_aid, :string
  end
end
