class Manage::StatisticsController < Manage::ApplicationController
  def index
    @statistics_presenter = StatisticsPresenter.new
  end
end
