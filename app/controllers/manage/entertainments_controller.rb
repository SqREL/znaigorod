class Manage::EntertainmentsController < Manage::ApplicationController
  actions :all, :except => :show

  belongs_to :organization, :singleton => true

  before_filter :redirect_to_edit, :only => :new, :if => :entertainment_exists?

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_entertainment_path(parent) and return
  end

  def entertainment_exists?
    parent.entertainment
  end
end
