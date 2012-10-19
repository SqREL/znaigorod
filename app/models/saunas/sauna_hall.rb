class SaunaHall < ActiveRecord::Base
  attr_accessible :title, :tour_link, :vfs_path

  belongs_to :sauna

  has_many :images, :as => :imageable,  :dependent => :destroy

  has_many :sauna_hall_schedules, :dependent => :destroy
  accepts_nested_attributes_for :sauna_hall_schedules, :allow_destroy => true, :reject_if => :all_blank
  attr_accessible :sauna_hall_schedules_attributes

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

# == Schema Information
#
# Table name: sauna_halls
#
#  id         :integer          not null, primary key
#  sauna_id   :integer
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tour_link  :string(255)
#  vfs_path   :text
#

