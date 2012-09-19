class SearchController < ApplicationController
  has_scope :page, :default => 1

  def search
    @search_presenter = SearchPresenter.new(:params => params)

    params.delete(:controller)
    params.delete(:action)

    redirect_to (@search_presenter.preferred_kind == 'affiches' ? search_affiches_path(params) : search_organizations_path(params))
  end

  def affiches
    @search_presenter = SearchPresenter.new(params: params.merge(kind: 'affiches'))

    render :index
  end

  def organizations
    @search_presenter = SearchPresenter.new(params: params.merge(kind: 'organizations'))

    render :index
  end
end
