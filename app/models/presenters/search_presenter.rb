class SearchPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :params

  def page
    params[:page] || 1
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:global, params)
  end

  def total
    searcher.total
  end

  def collection
    @collection ||= searcher.paginate(page: page, per_page: 10)
  end

  def hits
    HitDecorator.decorate collection.hits
  end

  def hits?
    !collection.total.zero?
  end
end
