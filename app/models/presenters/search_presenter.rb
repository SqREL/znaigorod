class SearchPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :params

  def initialize(options)
    super(options)
    params.delete(:action)
  end

  def page
    params[:page] || 1
  end

  def paginated_collection
    collection.paginate(page: page, per_page: 5)
  end

  def collection
    @collection ||= HasSearcher.searcher(:global, params)
  end

  def hits
    HitDecorator.decorate collection.hits
  end
end
