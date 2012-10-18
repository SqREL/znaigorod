class Sauna < ActiveRecord::Base
  attr_accessible :sauna_accessory_attributes

  belongs_to :organization

  has_one :sauna_accessory, :dependent => :destroy

  accepts_nested_attributes_for :sauna_accessory
end
