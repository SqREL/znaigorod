class SaunaHall < ActiveRecord::Base
  attr_accessible :title

  belongs_to :sauna

  has_one :sauna_hall_bath, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_bath
  attr_accessible :sauna_hall_bath_attributes

  has_one :sauna_hall_capacity, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_capacity
  attr_accessible :sauna_hall_capacity_attributes

  has_one :sauna_hall_entertainment, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_entertainment
  attr_accessible :sauna_hall_entertainment_attributes

  has_one :sauna_hall_interior, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_interior
  attr_accessible :sauna_hall_interior_attributes

  has_one :sauna_hall_stuff, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_stuff
  attr_accessible :sauna_hall_stuff_attributes

  has_one :sauna_hall_pool, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_pool
  attr_accessible :sauna_hall_pool_attributes

  has_one :sauna_hall_water_accessory, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_water_accessory
  attr_accessible :sauna_hall_water_accessory_attributes
end
