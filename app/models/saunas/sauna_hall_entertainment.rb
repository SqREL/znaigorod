class SaunaHallEntertainment < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :aerohockey, :billiard, :ping_pong
  attr_accessible :hookah, :karaoke, :tv, :guitar
  attr_accessible :checkers, :chess, :backgammon
end
