class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :description, :url

  belongs_to :attachable, :polymorphic => true
end
