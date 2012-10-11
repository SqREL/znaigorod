class SearchController < ApplicationController
  has_scope :page, :default => 1

  def search
    @search_presenter = SearchPresenter.new(:params => params)
    Searcher::Boostificator.new(:last_showing_time_dt).adjust_solr_params(@search_presenter.searcher)
    render partial: 'search_results_list', layout: false and return if request.xhr?
    render :index
  end
end
