class SaunaHallWaterAccessory < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :bucket, :jacuzzi
end

# == Schema Information
#
# Table name: sauna_hall_water_accessories
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  jacuzzi       :boolean
#  bucket        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

