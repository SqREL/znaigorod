class SearchController < ApplicationController
  helper_method :collection, :total

  protected
    def search
      @search ||= Sunspot.search([Affiche, Organization]) {
        keywords(params[:q])
        paginate(paginate_options)

        any_of do
          all_of do
            with(:kind, 'affiche')
            with(:last_showing_time).greater_than(DateTime.now)
          end

          all_of do
            with(:kind, 'organization')
          end
        end

        adjust_solr_params do |params|
          params[:q] = "{!boost b=recip(abs(ms(NOW/HOUR+1HOUR,first_showing_time_dt)),3.16e-11,1,1) defType=dismax}#{params[:q]}" unless params[:q].blank?
        end
      }
    end

    def collection
      @collection ||= search.results
    end

    def total
      search.total
    end
end
