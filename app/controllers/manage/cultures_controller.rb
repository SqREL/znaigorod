class Manage::CulturesController < Manage::ApplicationController
  belongs_to :organization, :singleton => true

  actions :all, :except => :show

  before_filter :redirect_to_edit, :only => :new, :if => :culture_exists?

  private
    def redirect_to_edit
      redirect_to edit_manage_organization_culture_path(parent) and return
    end

    def culture_exists?
      parent.culture
    end
end