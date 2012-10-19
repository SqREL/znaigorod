class SaunaStuff < ActiveRecord::Base
  belongs_to :sauna
  attr_accessible :safe, :wifi
end
