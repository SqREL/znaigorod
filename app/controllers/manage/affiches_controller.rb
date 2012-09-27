class Manage::AffichesController < Manage::ApplicationController
  actions :index, :new

  has_scope :page, :default => 1

  def statistics
    @statistics_presenter = StatisticsPresenter.new
  end

  protected
    def collection
      params[:include_gone] ? include_gone : only_actual
    end

    def only_actual
      showing_ids = HasSearcher.searcher(:showing, params[:search]).limit(1000).result_ids

      Affiche.search {
        keywords(params[:q])
        # NOTE: use [0] if showing_ids is empty
        with(:showing_ids, showing_ids + [0])
        paginate(paginate_options.merge(:per_page => per_page))

        adjust_solr_params do |params|
          params[:sort] = 'recip(abs(ms(NOW,first_showing_time_dt)),3.16e-11,1,1) desc'
        end

      }.results
    end

    def include_gone
      @search ||= Sunspot.search(Affiche) do
        keywords(params[:q])
        paginate(:page => params[:page], :per_page => per_page)
      end

      @search.results
    end
end
