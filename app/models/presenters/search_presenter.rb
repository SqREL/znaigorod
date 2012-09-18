class SearchPresenter
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment

  attr_accessor :params, :kind

  def initialize(options)
    super(options)
    @kind = params[:kind]
  end

  def searcher
    HasSearcher.searcher(:total, params).boost_by(:first_showing_time_dt)
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

  def affiches_link
    Link.new title: "#{I18n.t('search.affiches')} (#{affiches_count})",
             url: search_path(params.merge(kind: 'affiches'))
  end

  def organizations_link
    Link.new title: "#{I18n.t('search.organizations')} (#{organizations_count})",
             url: search_path(params.merge(kind: 'organizations'))
  end

  def affiches
    raw_affiches.map { |a| AfficheDecorator.new a }
  end

  def organizations
    OrganizationDecorator.decorate raw_organizations
  end

  def collection
    kind == 'affiches' ? affiches : organizations
  end
end
