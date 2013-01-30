class OrganizationStand < ActiveRecord::Base
  attr_accessible :guarded, :places, :video_observation

  belongs_to :organization

  include Rating
end

# == Schema Information
#
# Table name: organization_stands
#
#  id                :integer          not null, primary key
#  organization_id   :integer
#  places            :integer
#  guarded           :boolean
#  video_observation :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

