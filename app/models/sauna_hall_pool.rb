class SaunaHallPool < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :contraflow, :geyser, :size, :water_filter, :waterfall
end
