# encoding: utf-8

class Counter
  include ActiveAttr::MassAssignment
  attr_accessor :kind

  def today
    @today ||= searcher.today.group(:affiche_id_str).total
  end

  def weekend
    @weekend ||= searcher.weekend.group(:affiche_id_str).total
  end

  def weekly
    @weekly ||= searcher.weekly.group(:affiche_id_str).total
  end

  def all
    @all ||= searcher.actual.group(:affiche_id_str).total
  end

  private

  def searcher
    HasSearcher.searcher(:affiche, :affiche_category => kind.model_name.downcase)
  end
end
