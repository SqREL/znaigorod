HasSearcher.create_searcher :affiche do
  models :showing

  property :affiche_category
  property :starts_on
  property :tags

  scope :today do
    with(:starts_at).greater_than DateTime.now.beginning_of_day
    with(:starts_at).less_than DateTime.now.end_of_day
  end

  scope :weekend do
    with(:starts_at).greater_than DateTime.now.end_of_week - 2.days + 1.second
    with(:starts_at).less_than DateTime.now.end_of_week
  end

  scope :weekly do
    with(:starts_at).greater_than DateTime.now.beginning_of_week
    with(:starts_at).less_than DateTime.now.end_of_week
  end

  scope :daily do |search|
    search.with(:starts_at).greater_than search_object.starts_on.beginning_of_day
    search.with(:starts_at).less_than search_object.starts_on.end_of_day
  end

  scope :actual do |search|
    search.with(:starts_at).greater_than DateTime.now.change(:sec => 0)
    search.any_of do
      with(:ends_at).greater_than(DateTime.now.change(:sec => 0))
      with(:ends_at, nil)
    end
  end

  group :affiche_id_str

  scope do
    order_by :starts_at
  end

  scope :faceted do
    facet(:tags)
  end
end

HasSearcher.create_searcher :photoreport do
  models :image

  group :imageable_id_str

  scope :weekly do
    with(:created_at).greater_than DateTime.now - 1.week
  end

  scope :monthly do
    with(:created_at).greater_than DateTime.now - 1.month
  end

  scope do
    with(:imageable_type, 'Affiche')
    order_by :id, :desc
  end
end

HasSearcher.create_searcher :actual_organization do
  models :meal, :entertainment

  property :meal_offer
  property :meal_category

  property :entertainment_category
  property :entertainment_offer

  scope do
    adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_fs}*:*" }
  end
end

HasSearcher.create_searcher :meal do
  models :meal
end

HasSearcher.create_searcher :entertainment do
  models :entertainment
end

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
    starts_on_gt = search_object.starts_on_greater_than || Date.today
    ends_at_gt = search_object.starts_on_less_than || Date.today + 1.week

    search.any_of do
      with(:starts_on).greater_than(starts_on_gt)
      with(:ends_at).greater_than(ends_at_gt)
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
