class AddBoardGamesAndGuitarToSaunaHallEntertainments < ActiveRecord::Migration
  def change
    add_column :sauna_hall_entertainments, :checkers, :integer
    add_column :sauna_hall_entertainments, :chess, :integer
    add_column :sauna_hall_entertainments, :backgammon, :integer
    add_column :sauna_hall_entertainments, :guitar, :integer
  end
end
