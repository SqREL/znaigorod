class SaunaHall < ActiveRecord::Base
  attr_accessible :title, :sauna_hall_capacity_attributes

  belongs_to :sauna

  has_one :sauna_hall_capacity, :dependent => :destroy

  accepts_nested_attributes_for :sauna_hall_capacity
end
