class AddOfferToServices < ActiveRecord::Migration
  def change
    add_column :services, :offer, :text
  end
end
