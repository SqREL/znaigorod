class MealsController < OrganizationsController
  defaults :resource_class => Meal

  def index
    @presenter = MealsCollection.new(params)
  end
end
