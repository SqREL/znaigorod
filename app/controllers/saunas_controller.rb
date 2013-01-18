class SaunasController < ApplicationController
  def index
    @presenter = SaunaHallsPresenter.new(params)
    render partial: 'sauna_list', layout: false and return if request.xhr?
  end
end
