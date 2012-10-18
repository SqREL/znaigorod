class CreateSaunaHallEntertainments < ActiveRecord::Migration
  def change
    create_table :sauna_hall_entertainments do |t|
      t.references :sauna_hall
      t.integer :karaoke
      t.integer :tv
      t.integer :billiard
      t.integer :instruments
      t.integer :board_games
      t.integer :ping_pong
      t.integer :hookah

      t.timestamps
    end
    add_index :sauna_hall_entertainments, :sauna_hall_id
  end
end
