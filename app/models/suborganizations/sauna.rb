# encoding: utf-8

class Sauna < Entertainment
  attr_accessible :sauna_accessory_attributes, :sauna_alcohol_attributes,
    :sauna_broom_attributes, :sauna_massage_attributes,
    :sauna_oil_attributes, :sauna_stuff_attributes,
    :sauna_child_stuff_attributes

  has_many :sauna_halls, :dependent => :destroy

  has_one :sauna_accessory,   :dependent => :destroy
  has_one :sauna_broom,       :dependent => :destroy
  has_one :sauna_alcohol,     :dependent => :destroy
  has_one :sauna_oil,         :dependent => :destroy
  has_one :sauna_child_stuff, :dependent => :destroy
  has_one :sauna_stuff,       :dependent => :destroy
  has_one :sauna_massage,     :dependent => :destroy

  accepts_nested_attributes_for :sauna_accessory
  accepts_nested_attributes_for :sauna_broom
  accepts_nested_attributes_for :sauna_alcohol
  accepts_nested_attributes_for :sauna_oil
  accepts_nested_attributes_for :sauna_child_stuff
  accepts_nested_attributes_for :sauna_stuff
  accepts_nested_attributes_for :sauna_massage

  delegate :title, :to => :organization, :prefix => true
end

# == Schema Information
#
# Table name: entertainments
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  description     :text
#  type            :string(255)
#

