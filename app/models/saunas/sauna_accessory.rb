class SaunaAccessory < ActiveRecord::Base
  attr_accessible :sheets, :sneakers, :bathrobes, :towels, :brooms, :oils,
                  :ability_brooms, :ability_oils

  belongs_to :sauna
end
