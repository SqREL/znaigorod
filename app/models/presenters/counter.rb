# encoding: utf-8

class Counter
  include ActiveAttr::MassAssignment
  attr_accessor :kind

  def today
    @today ||= searcher.today.group(:affiche_id_str).total
  end

  def weekend
    @weekend ||= searcher.weekend.actual.group(:affiche_id_str).total
  end

  def weekly
    @weekly ||= searcher.weekly.actual.group(:affiche_id_str).total
  end

  def all
    @all ||= searcher.actual.group(:affiche_id_str).total
  end


  def searcher
    search_params = {}
    search_params[:affiche_category] = kind.singularize unless kind == 'affiche'
    HasSearcher.searcher(:affiche, search_params)
  end
end
