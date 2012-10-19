class SaunaHallInterior < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :floors, :lounges
end
