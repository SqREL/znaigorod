class AddVkontakteLikesToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :vkontakte_likes, :integer
  end
end
