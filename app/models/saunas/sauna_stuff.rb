class SaunaStuff < ActiveRecord::Base
  belongs_to :sauna
  attr_accessible :safe, :wifi
end

# == Schema Information
#
# Table name: sauna_stuffs
#
#  id         :integer          not null, primary key
#  sauna_id   :integer
#  wifi       :integer
#  safe       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

