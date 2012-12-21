class SaunasController < ApplicationController
  def index
    @collection = SaunaHallPresenter.new(params).collection
  end
end
