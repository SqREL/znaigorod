class SearchPresenter
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment

  attr_accessor :params, :kind

  def initialize(options)
    super(options)

    @kind = params.delete(:kind)
    params.delete(:action)
  end

  def page
    params[:page] || 1
  end

  def organizations_searcher
    HasSearcher.searcher(:organizations, params).order_by_rating
  end

  def organizations_count
    organizations_searcher.total
  end

  def paginated_organizations
    organizations_searcher.paginate(page: page, per_page: 5).results
  end

  def organizations
    OrganizationDecorator.decorate paginated_organizations
  end

  def showings_searcher
    HasSearcher.searcher(:showings, params)
  end

  def affiches_count
    showings_searcher.affiche_groups.group(:affiche_id_str).total
  end

  def paginated_affiches
    showings_searcher.boost_by(:starts_at_dt).paginate(page: page, per_page: 5).affiche_groups
  end

  def affiches
    paginated_affiches.group(:affiche_id_str).groups.map(&:value).map { |id| Affiche.find(id) }.map { |a| AfficheDecorator.new a }
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



  def paginated_collection
    affiches? ? paginated_affiches : paginated_organizations
  end



  def affiches?
    kind == 'affiches'
  end

  def collection
    affiches? ? affiches : organizations
  end
end
