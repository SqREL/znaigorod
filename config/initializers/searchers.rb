HasSearcher.create_searcher :affiche do
  models :showing

  property :affiche_category
  property :starts_on
  property :tags
  property :affiche_id
  property :organization_id

  scope :today do
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
    search.with(:starts_at).greater_than DateTime.now.beginning_of_day
    search.any_of do
      with(:ends_at).greater_than(DateTime.now.beginning_of_day)
      with(:ends_at, nil)
    end
  end

  scope :affiches do
    group :affiche_id_str
  end

  scope do
    with(:starts_at).greater_than DateTime.now.beginning_of_day
  end

  scope :order_by_starts_at do
    order_by(:starts_at, :asc)
  end

  scope :order_by_affiche_created_at do
    order_by(:affiche_created_at, :desc)
  end

  scope :order_by_affiche_popularity do
    order_by(:affiche_popularity, :desc)
  end

  scope :faceted do
    facet(:tags)
  end
end

HasSearcher.create_searcher :similar_affiches do
  models :affiche

  scope do
    with(:last_showing_time).greater_than HasSearcher.cacheable_now
  end

  scope :with_images do
    with(:has_images, true)
  end
end

HasSearcher.create_searcher :photoreport do
  models :image

  property :category
  property :tags

  scope :weekly do
    with(:created_at).greater_than 1.week.ago.beginning_of_day
  end

  scope :monthly do
    with(:created_at).greater_than 1.month.ago.beginning_of_day
  end

  scope do
    facet(:category)
    facet(:tags)

    order_by :id, :desc

    with(:imageable_type, 'Affiche')
  end

  scope :grouped do
    group :imageable_id_str
  end
end

HasSearcher.create_searcher :actual_organization do
  models :meal, :entertainment, :culture

  property :meal_offer
  property :meal_category

  property :entertainment_category
  property :entertainment_offer

  property :culture_category
  property :culture_offer

  scope do
    adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
  end
end

HasSearcher.create_searcher :meal do
  models :meal

  property :meal_category
  property :meal_feature
  property :meal_offer
  property :meal_cuisine

  scope do
    adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }

    facet(:meal_category)
    facet(:meal_feature)
    facet(:meal_offer)
    facet(:meal_cuisine)
  end
end

HasSearcher.create_searcher :entertainment do
  models :entertainment

  property :entertainment_category
  property :entertainment_feature
  property :entertainment_offer

  scope do
    adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }

    facet(:entertainment_category)
    facet(:entertainment_feature)
    facet(:entertainment_offer)
  end
end

HasSearcher.create_searcher :culture do
  models :culture

  property :culture_category
  property :culture_feature
  property :culture_offer

  scope do
    adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_fs}*:*" }

    facet(:culture_category)
    facet(:culture_feature)
    facet(:culture_offer)
  end
end

HasSearcher.create_searcher :organizations do
  models :organization
  keywords :q

  scope :order_by_rating do
    order_by(:rating, :desc)
  end

  # NOTE: как передать значения в scope? o_O
  scope :nearest do |search|
    search.with(:location).in_radius(search_object.latitude, search_object.longitude, 0.5, bbox: true)
    search.order_by_geodist(:location, search_object.latitude, search_object.longitude)
  end
end

HasSearcher.create_searcher :showings do
  models :showing
  keywords :q

  scope :affiche_groups do
    group(:affiche_id_str)
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
    ends_at_gt = search_object.starts_on_less_than || 1.week.since.to_date

    search.any_of do
      with(:starts_on).greater_than(starts_on_gt)
      with(:ends_at).greater_than(ends_at_gt)
    end
  end

  scope :actual do
    with(:starts_at).greater_than HasSearcher.cacheable_now
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

HasSearcher.create_searcher :global do
  models :organization, :affiche
  keywords :q do
    highlight :title_ru
    highlight :description_ru
    HitDecorator::ADDITIONAL_FIELDS.each do |field|
      highlight field
    end
  end
end
