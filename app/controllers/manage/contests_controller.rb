class Manage::ContestsController < Manage::ApplicationController
  actions :all

  def index
    @collection = Contest.page(params[:page] || 1).per(10)
  end
end
