class SaunaHall < ActiveRecord::Base
  attr_accessible :title

  belongs_to :sauna

  has_one :sauna_hall_capacity, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_capacity
  attr_accessible :sauna_hall_capacity_attributes

  has_one :sauna_hall_entertainment, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_entertainment
  attr_accessible :sauna_hall_entertainment_attributes

end
