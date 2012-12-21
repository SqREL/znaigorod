class SaunaHallPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :price_min, :price_max, :page

  def initialize(args)
    super(args)

    self.page ||= 1
  end

  def collection
    search.results
  end

  def search
    SaunaHall.search {
      without(:price_max).less_than(price_min) if price_min
      without(:price_min).greater_than(price_max) if price_max

      paginate(:page => page)
    }
  end
end
