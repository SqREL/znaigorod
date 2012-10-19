class SaunaAccessory < ActiveRecord::Base
  attr_accessible :sheets, :sneakers, :bathrobes, :towels, :brooms, :oils,
                  :ability_brooms, :ability_oils

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_accessories
#
#  id             :integer          not null, primary key
#  sauna_id       :integer
#  sheets         :integer
#  sneakers       :integer
#  bathrobes      :integer
#  towels         :integer
#  brooms         :integer
#  oils           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ability_brooms :integer
#  ability_oils   :integer
#

