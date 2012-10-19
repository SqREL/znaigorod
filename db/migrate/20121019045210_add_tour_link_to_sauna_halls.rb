class AddTourLinkToSaunaHalls < ActiveRecord::Migration
  def change
    add_column :sauna_halls, :tour_link, :string
  end
end
