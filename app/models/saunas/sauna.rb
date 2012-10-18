class Sauna < ActiveRecord::Base
  attr_accessible :sauna_accessory_attributes

  belongs_to :organization

  has_many :sauna_halls, :dependent => :destroy

  has_one :sauna_accessory, :dependent => :destroy

  accepts_nested_attributes_for :sauna_accessory

  delegate :title, :to => :organization
end
