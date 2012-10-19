class SaunaHallInterior < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :floors, :lounges
end

# == Schema Information
#
# Table name: sauna_hall_interiors
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  floors        :integer
#  lounges       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

