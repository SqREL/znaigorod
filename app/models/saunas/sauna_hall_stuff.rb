class SaunaHallStuff < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :barbecue, :pit, :pylon
end

# == Schema Information
#
# Table name: sauna_hall_stuffs
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  pit           :integer
#  pylon         :integer
#  barbecue      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

