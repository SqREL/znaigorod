class SaunaHallBath < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :finnish, :infrared, :japanese, :russian, :turkish
end
