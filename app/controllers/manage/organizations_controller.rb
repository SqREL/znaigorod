class Manage::OrganizationsController < Manage::ApplicationController
  has_scope :ordered_by_updated_at, :default => 1
  belongs_to :organization, :optional => true

  private
    def build_resource
      super

      resource.build_address unless resource.address

      (1..7).each do |day|
        resource.schedules.build(:day => day)
      end unless resource.schedules.any?

      resource
    end
end
