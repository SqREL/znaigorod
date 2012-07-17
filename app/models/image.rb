class Image < ActiveRecord::Base
  attr_accessible :description, :url

  belongs_to :imageable, :polymorphic => true

  default_scope :order => :id

  validates_presence_of :description, :url
end

# == Schema Information
#
# Table name: images
#
#  id             :integer         not null, primary key
#  url            :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  description    :text
#  imageable_type :string(255)
#  imageable_id   :integer
#

