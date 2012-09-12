class MealsController < OrganizationsController
  defaults :resource_class => Meal

  def index
    render :text => params.inspect and return
  end
end
