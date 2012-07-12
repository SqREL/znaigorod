class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :description, :url

  belongs_to :attachable, :polymorphic => true

  validates_presence_of :description
end
