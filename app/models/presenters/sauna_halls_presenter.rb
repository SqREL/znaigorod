class SaunaHallsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :capacity_min, :capacity_max,
                :price_min, :price_max,
                :baths,
                :pool,
                :page

  alias :pool_features :pool

  def initialize(args = {})
    super(args)

    self.page ||= 1
    self.pool = (self.pool || []).delete_if(&:blank?)
    self.baths = (self.baths || []).delete_if(&:blank?)
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

      pool_features.each do |feature|
        with(:pool_features, feature)
      end

      baths.each do |bath|
        with(:baths, bath)
      end

      paginate(:page => page)
    }
  end
end
