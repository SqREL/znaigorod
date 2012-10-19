class SaunaHallWaterAccessory < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :bucket, :jacuzzi
end
