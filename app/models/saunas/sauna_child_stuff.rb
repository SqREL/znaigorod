class SaunaChildStuff < ActiveRecord::Base
  attr_accessible :cartoons, :games, :life_jacket, :rubber_ring

  belongs_to :sauna
end
