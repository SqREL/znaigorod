class SaunaHall < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :title, :tour_link, :vfs_path, :description, :sauna_hall_schedules_attributes,
    :sauna_hall_bath_attributes, :sauna_hall_capacity_attributes, :sauna_hall_entertainment_attributes,
    :sauna_hall_interior_attributes, :sauna_hall_pool_attributes

  belongs_to :sauna

  has_many :images, :as => :imageable,  :dependent => :destroy
  has_many :sauna_hall_schedules,       :dependent => :destroy

  has_one :sauna_hall_bath, :dependent => :destroy
  has_one :sauna_hall_capacity, :dependent => :destroy
  has_one :sauna_hall_entertainment, :dependent => :destroy
  has_one :sauna_hall_interior, :dependent => :destroy
  has_one :sauna_hall_pool, :dependent => :destroy

  accepts_nested_attributes_for :sauna_hall_bath
  accepts_nested_attributes_for :sauna_hall_capacity
  accepts_nested_attributes_for :sauna_hall_entertainment
  accepts_nested_attributes_for :sauna_hall_interior
  accepts_nested_attributes_for :sauna_hall_pool
  accepts_nested_attributes_for :sauna_hall_schedules, :allow_destroy => true, :reject_if => :all_blank

  searchable do
    integer :price_min
    integer :price_max
  end

  include Rating
  use_for_rating :sauna_hall_bath, :sauna_hall_capacity, :sauna_hall_entertainment, :sauna_hall_interior, :sauna_hall_pool

  def summary_rating_with_images
    summary_rating_without_images + images.count
  end

  alias_method_chain :summary_rating, :images

  def min_sauna_hall_schedules_price
    sauna_hall_schedules.pluck(:price).min
  end

  def max_sauna_hall_schedules_price
    sauna_hall_schedules.pluck(:price).max
  end

  alias_method :price_min, :min_sauna_hall_schedules_price
  alias_method :price_max, :max_sauna_hall_schedules_price
end

# == Schema Information
#
# Table name: sauna_halls
#
#  id          :integer          not null, primary key
#  sauna_id    :integer
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tour_link   :string(255)
#  vfs_path    :text
#  description :text
#

