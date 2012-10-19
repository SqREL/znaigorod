class Sauna < ActiveRecord::Base
  belongs_to :organization

  has_many :sauna_halls, :dependent => :destroy

  has_one :sauna_accessory, :dependent => :destroy
  accepts_nested_attributes_for :sauna_accessory
  attr_accessible :sauna_accessory_attributes

  has_one :sauna_child_stuff, :dependent => :destroy
  accepts_nested_attributes_for :sauna_child_stuff
  attr_accessible :sauna_child_stuff_attributes

  has_one :sauna_stuff, :dependent => :destroy
  accepts_nested_attributes_for :sauna_stuff
  attr_accessible :sauna_stuff_attributes

  has_one :sauna_massage, :dependent => :destroy
  accepts_nested_attributes_for :sauna_massage
  attr_accessible :sauna_massage_attributes

  delegate :title, :to => :organization
end

# == Schema Information
#
# Table name: saunas
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

