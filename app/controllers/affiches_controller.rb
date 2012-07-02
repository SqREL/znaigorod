# encoding: utf-8

class AffichesController < ApplicationController
  actions :index, :show

  has_scope :page, :default => 1

  layout 'public'

  def index
    if request.xhr?
      render :text => '<div class="empty">Ничего не найдено ;(</div>', :layout => false and return if collection.empty?
      render :partial => 'commons/list', :locals => { :collection => collection, :remote => true }, :layout => false and return
    end

    index!
  end

  protected
    def collection
      search_results
    end

    def search_results
      showing_ids = ShowingSearch.new(params[:search]).result_ids

      Affiche.search {
        # NOTE: use [0] if showing_ids is empty
        with(:showing_ids, showing_ids + [0])
        paginate(paginate_options)

        adjust_solr_params do |params|
          params[:sort] = 'recip(abs(ms(NOW,first_showing_time_dt)),3.16e-11,1,1) desc'
        end

      }.results
    end
end
