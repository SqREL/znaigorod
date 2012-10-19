class SaunaHallSchedule < ActiveRecord::Base
  attr_accessible :day, :from, :price, :to

  belongs_to :sauna_hall

  default_value_for :day, 1
end
