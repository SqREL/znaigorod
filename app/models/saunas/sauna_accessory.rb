class SaunaAccessory < ActiveRecord::Base
  attr_accessible :sheets, :sneakers, :bathrobes, :towels, :brooms, :oils

  belongs_to :sauna
end
