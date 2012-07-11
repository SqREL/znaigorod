class Image < ActiveRecord::Base
  attr_accessible :description, :url

  default_scope :order => :updated_at

  belongs_to :imageable, :polymorphic => true
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

