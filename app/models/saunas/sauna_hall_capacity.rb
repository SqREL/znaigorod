class SaunaHallCapacity < ActiveRecord::Base
  attr_accessible :default, :maximal, :extra_guest_cost

  belongs_to :sauna_hall
end
