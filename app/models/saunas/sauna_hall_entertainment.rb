class SaunaHallEntertainment < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :aerohockey, :billiard, :hookah, :karaoke, :ping_pong, :tv
end
