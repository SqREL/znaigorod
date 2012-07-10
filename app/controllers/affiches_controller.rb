# encoding: utf-8

class AffichesController < ApplicationController
  inherit_resources

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
      @collection ||= search_results
    end

    def search_results
      search_params = params[:search] || {:starts_on_greater_than => Date.today, :starts_on_less_than => (Date.today + 6.days).end_of_day}

      @affiches_hash = HasSearcher.searcher(:showing, search_params).limit(1_000).order_by(:starts_at).results.group_by(&:affiche)

      @affiches_hash.each do |affiche, showings|
        @affiches_hash[affiche] = showings.group_by(&:starts_on)
      end

      @affiches_hash.keys[((page - 1) * per_page)...(page * per_page)]
    end
end
