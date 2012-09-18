class SearchController < ApplicationController
  def index
    @search_presenter = SearchPresenter.new(:params => params)
  end
end
