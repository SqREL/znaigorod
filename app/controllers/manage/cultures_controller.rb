class Manage::CulturesController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => [:index, :show]

  belongs_to :organization

  before_filter :redirect_to_edit, :only => :new, :if => :culture_exists?

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_culture_path(parent) and return
  end

  def culture_exists?
    parent.culture
  end
end
