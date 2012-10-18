class SaunaHall < ActiveRecord::Base
  attr_accessible :title

  belongs_to :sauna
end
