class SaunaHallsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :capacity_min, :capacity_max,
                :price_min, :price_max,
                :baths, :features, :pool,
                :lat, :lon, :radius,
                :page

  alias :pool_features :pool

  def initialize(args = {})
    super(args)

    self.baths    = (self.baths || []).delete_if(&:blank?)
    self.features = (self.features || []).delete_if(&:blank?)
    self.pool     = (self.pool || []).delete_if(&:blank?)
    self.lat      ||= '56.488611121111'
    self.lon      ||= '84.952222232222'
    self.radius   ||= 11
    self.page     ||= 1
  end

  def capacity
    Hashie::Mash.new(
      available: { minimum: SaunaHallCapacity.maximum(:maximal), maximum: SaunaHallCapacity.maximum(:maximal) },
      selected: { minimum: capacity_min, maximum: capacity_max }
    )
  end

  def price
    Hashie::Mash.new(
      available: { minimum: SaunaHallSchedule.minimum(:price), maximum: SaunaHallSchedule.maximum(:price) },
      selected: { minimum: price_min, maximum: price_max }
    )
  end

  def search
    @search ||= SaunaHall.search {
      with(:capacity).greater_than_or_equal_to(capacity_min)  if capacity_min
      with(:capacity).less_than_or_equal_to(capacity_max)     if capacity_max

      without(:price_max).less_than(price_min)    if price_min
      without(:price_min).greater_than(price_max) if price_max

      baths.each do |bath|
        with(:baths, bath)
      end

      features.each do |feature|
        with(:features, feature)
      end

      pool_features.each do |feature|
        with(:pool_features, feature)
      end

      with(:location).in_radius(lat, lon, radius)

      facet :baths,         sort: :index, zeros: true
      facet :features,      sort: :index, zeros: true
      facet :pool_features, sort: :index, zeros: true

      paginate(:page => page, :per_page => 1000)
    }
  end

  def collection
    search.results
  end

  def total_count
    search.total
  end

  def faceted_rows(facet)
    [*search.facet(facet).rows.map(&:value)]
  end

  %w[baths features pool_features].each do |name|
    define_method "available_#{name}" do
      faceted_rows name
    end

    define_method "selected_#{name}" do
      send("available_#{name}") & send(name)
    end
  end
end
