class SaunaHallEntertainment < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :billiard, :board_games, :hookah, :instruments, :karaoke, :ping_pong, :tv
end
