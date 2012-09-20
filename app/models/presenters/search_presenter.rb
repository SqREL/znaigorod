class SearchPresenter
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment

  attr_accessor :params, :kind

  def initialize(options)
    super(options)

    @kind = params.delete(:kind)
    params.delete(:action)
  end

  def searcher
    HasSearcher.searcher(:total, params).boost_by(:first_showing_time_dt)
  end

  def page
    params[:page] || 1
  end

  def raw_affiches
    searcher.affiches.results
  end

  def affiches_count
    searcher.affiches.total
  end

  def raw_organizations
    searcher.organizations.results
  end

  def organizations_count
    searcher.organizations.total
  end

  def params_without_page
    params.clone.tap { |p| p.delete(:page) }
  end

  def preferred_kind
    affiches_count > organizations_count ? 'affiches' : 'organizations'
  end

  def affiches_link
    html_options = {}
    html_options.merge!(class: 'disabled') if affiches_count.zero?

    Link.new title: "#{I18n.t('search.affiches')} (#{affiches_count})",
             url: search_affiches_path(params_without_page),
             html_options: html_options
  end

  def organizations_link
    html_options = {}
    html_options.merge!(class: 'disabled') if organizations_count.zero?

    Link.new title: "#{I18n.t('search.organizations')} (#{organizations_count})",
             url: search_organizations_path(params_without_page),
             html_options: html_options
  end

  def paginated_affiches
    searcher.affiches.paginate(page: page, per_page: 10).results
  end

  def paginated_organizations
    searcher.organizations.paginate(page: page, per_page: 10).results
  end

  def paginated_collection
    affiches? ? paginated_affiches : paginated_organizations
  end

  def affiches
    paginated_affiches.map { |a| AfficheDecorator.new a }
  end

  def organizations
    OrganizationDecorator.decorate paginated_organizations
  end

  def affiches?
    kind == 'affiches'
  end

  def collection
    affiches? ? affiches : organizations
  end
end
