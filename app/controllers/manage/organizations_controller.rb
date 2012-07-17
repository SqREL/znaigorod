class Manage::OrganizationsController < Manage::ApplicationController
  has_scope :ordered_by_updated_at, :default => true, :type => :boolean
  has_scope :page, :default => 1
  has_scope :parental, :default => true, :type => :boolean, :only => :index

  belongs_to :organization, :optional => true

  respond_to :html, :json

  private

    alias_method :old_collection, :collection

    def collection
      if params[:utf8]
        HasSearcher.searcher(:manage_organization, params).results
      else
        old_collection
      end
    end

    def build_resource
      super

      resource.build_address unless resource.address

      ((1..6).to_a + [0]).each do |day|
        resource.schedules.build(:day => day)
      end unless resource.schedules.any?

      resource
    end

end
