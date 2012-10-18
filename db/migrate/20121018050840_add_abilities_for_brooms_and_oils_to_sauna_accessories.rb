class AddAbilitiesForBroomsAndOilsToSaunaAccessories < ActiveRecord::Migration
  def change
    add_column :sauna_accessories, :ability_brooms, :integer
    add_column :sauna_accessories, :ability_oils, :integer
  end
end
