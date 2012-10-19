class SaunaHallPool < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :contraflow, :geyser, :size, :water_filter, :waterfall
end

# == Schema Information
#
# Table name: sauna_hall_pools
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  size          :string(255)
#  contraflow    :boolean
#  geyser        :boolean
#  waterfall     :boolean
#  water_filter  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

