class SaunaHallsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :capacity_min, :capacity_max,
                :price_min, :price_max,
                :baths, :features, :pool,
                :lat, :lon, :radius,
                :order_by, :direction,
                :page

  alias :pool_features  :pool

  def initialize(args = {})
    super(args)

    self.capacity_min = self.capacity_min.to_i.zero? ? SaunaHallCapacity.minimum(:default) : self.capacity_min.to_i
    self.capacity_max = self.capacity_max.to_i.zero? ? SaunaHallCapacity.maximum(:maximal) : self.capacity_max.to_i
    self.price_min    = self.price_min.blank? ?  SaunaHallSchedule.minimum(:price) : self.price_min
    self.price_max    = self.price_max.blank? ?  SaunaHallSchedule.maximum(:price) : self.price_max
    self.radius       = self.radius.blank? ? nil : self.radius

    self.baths    = (self.baths || []).delete_if(&:blank?)
    self.features = (self.features || []).delete_if(&:blank?)
    self.pool     = (self.pool || []).delete_if(&:blank?)

    self.lat    ||= 56.488611121111
    self.lon    ||= 84.952222232222
    self.page   ||= 1

    self.order_by  = %w[distance popularity price].include?(self.order_by) ? self.order_by : 'popularity'
  end

  def criterion
    order_by == 'price' ? 'price_min' : order_by

    # NOTE: stub
    'price_min'
  end

  def direction
    criterion == 'popularity' ? 'desc' : 'asc'
  end

  def order_by_distance?
    order_by == 'distance'
  end

  def capacity
    Hashie::Mash.new(
      available: { minimum: SaunaHallCapacity.minimum(:default), maximum: SaunaHallCapacity.maximum(:maximal) },
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
      with(:capacity).between(capacity_min..capacity_max)

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

      if order_by_distance?
        with(:location).in_radius(lat, lon, radius)

        order_by_geodist(:location, lat, lon)
      else
        order_by(criterion, direction)
      end

      facet :baths,         sort: :index, zeros: true
      facet :features,      sort: :index, zeros: true
      facet :pool_features, sort: :index, zeros: true

      paginate(:page => page, :per_page => 100_000_000)
    }
  end

  def price_filter_used?
    price.selected.values.compact.any?
  end

  def capacity_filter_used?
    capacity.selected.values.compact.any?
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

    define_method "#{name}_filter_used?" do
      send("selected_#{name}").any?
    end
  end
end
