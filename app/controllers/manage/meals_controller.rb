class Manage::MealsController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => [:index, :show]

  belongs_to :organization

  before_filter :redirect_to_edit, :only => :new, :if => :meal_exists?

  private
    def redirect_to_edit
      redirect_to edit_manage_organization_meal_path(parent) and return
    end

    def meal_exists?
      parent.meal
    end
end
