class Manage::OrganizationsController < Manage::ApplicationController
  has_scope :ordered_by_updated_at, :default => true, :type => :boolean
  has_scope :page, :default => 1
  has_scope :parental, :default => true, :type => :boolean, :only => :index

  belongs_to :organization, :optional => true

  before_filter :build_resource, :only => :new
  before_filter :build_nested_objects, :only => [:new, :edit]

  respond_to :html, :json

  private

  def build_nested_objects
    resource.organization_stand || resource.build_organization_stand
    resource.address || resource.build_address

    ((1..6).to_a + [0]).each do |day|
      resource.schedules.build(:day => day)
    end unless resource.schedules.any?
  end

  alias_method :old_collection, :collection

  def collection
    if params[:utf8]
      HasSearcher.searcher(:manage_organization, params).paginate(:page => params[:page], :per_page => per_page).results
    else
      old_collection
    end
  end
end
