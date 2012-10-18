class Manage::SaunasController < Manage::ApplicationController
  actions :all, :except => [:index, :show]

  defaults :singleton => true

  belongs_to :organization

  before_filter :redirect_to_edit, :only => :new, :if => :sauna_exists?

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_sauna_path(parent) and return
  end

  def sauna_exists?
    parent.sauna
  end
end
