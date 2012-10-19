class SaunaHallStuff < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :barbecue, :pit, :pylon
end
