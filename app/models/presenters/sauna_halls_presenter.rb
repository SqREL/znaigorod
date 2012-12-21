class SaunaHallsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :capacity_min, :capacity_max, :price_min, :price_max, :page

  def initialize(args = {})
    super(args)

    self.page ||= 1
  end

  def collection
    search.results
  end

  def search
    SaunaHall.search {
      with(:capacity).greater_than_or_equal_to(capacity_min) if capacity_min
      with(:capacity).less_than_or_equal_to(capacity_max) if capacity_max

      without(:price_max).less_than(price_min) if price_min
      without(:price_min).greater_than(price_max) if price_max

      paginate(:page => page)
    }
  end
end
