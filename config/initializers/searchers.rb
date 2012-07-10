HasSearcher.create_searcher :total do
  models :affiche, :organization
  keywords :q

  scope do |sunspot|
    sunspot.any_of do
      with(:last_showing_time).greater_than(DateTime.now)
      with(:kind, :organization)
    end
  end
end

HasSearcher.create_searcher :showing do
  models :showing

  property :affiche_id
  property :affiche_category
  property :starts_on, :modificator => :less_than
  property :starts_at, :modificator => :greater_than
  property :starts_at_hour, :modificators => [:greater_than, :less_than]
  property :price, :modificators => [:greater_than, :less_than] do |search|
    if search_object.price_greater_than || search_object.price_less_than
      price_gt = [0, search_object.price_greater_than.to_i].max
      price_lt = search_object.price_less_than.to_i.zero? ? 10_000_000 : search_object.price_less_than.to_i

      search.with(:price_min).greater_than(price_gt)
      search.with(:price_min).less_than(price_lt)

      search.any_of do
        all_of do
          with(:price_min).greater_than(price_gt)
          with(:price_max).less_than(price_lt)
        end

        all_of do
          with(:price_min).less_than(price_gt)
          with(:price_max).greater_than(price_gt)
        end

        all_of do
          with(:price_min).less_than(price_lt)
          with(:price_max).greater_than(price_lt)
        end
      end
    end
  end
  property :tags
  property :affiche_category

  property :starts_on, :modificator => :greater_than do |search|
    starts_on_gt = Date.today

    search.any_of do
      with(:starts_on).greater_than(starts_on_gt)
      with(:ends_at).greater_than(DateTime.now)
    end
  end

  scope :actual do
    with(:starts_at).greater_than DateTime.now
  end

  scope :today do
    with(:starts_at).less_than DateTime.now.end_of_day
  end

  scope :faceted do
    facet(:tags)
  end
end

HasSearcher.create_searcher :manage_organization do
  models :organization
  keywords :q
end
