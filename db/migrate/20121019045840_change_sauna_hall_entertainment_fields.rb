class ChangeSaunaHallEntertainmentFields < ActiveRecord::Migration
  def up
    change_table :sauna_hall_entertainments do |t|
      t.remove :instruments
      t.remove :board_games
      t.integer :aerohockey
    end
  end

  def down
    change_table :sauna_hall_entertainments do |t|
      t.integer :instruments
      t.integer :board_games
      t.remove :aerohockey
    end
  end
end
