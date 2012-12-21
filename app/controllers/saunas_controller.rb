class SaunasController < ApplicationController
  def index
    @presenter = SaunaHallsPresenter.new(params)
  end
end
