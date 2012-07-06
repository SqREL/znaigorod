class Manage::MealsController < Manage::ApplicationController
  belongs_to :organization, :singleton => true
  actions :all, :except => :show
  before_filter :redirect_to_edit, :only => :new, :if => :meal_exists?

  private
    def redirect_to_edit
      redirect_to edit_manage_organization_meal_path(parent) and return
    end

    def meal_exists?
      parent.meal
    end
end