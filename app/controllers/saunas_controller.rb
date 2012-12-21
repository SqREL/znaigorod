class SaunasController < ApplicationController
  def index
    @presenter = SaunaHallPresenter.new(params)
  end
end
