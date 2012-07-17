class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :description, :url

  belongs_to :attachable, :polymorphic => true

  validates_presence_of :description, :url
end
# == Schema Information
#
# Table name: attachments
#
#  id              :integer         not null, primary key
#  attachable_id   :integer
#  attachable_type :string(255)
#  url             :string(255)
#  description     :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

