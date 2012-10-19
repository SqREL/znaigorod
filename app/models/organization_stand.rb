class OrganizationStand < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :guarded, :places, :video_observation
end
