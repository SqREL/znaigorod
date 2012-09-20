# encoding: utf-8

class Photogallery
  include ActiveAttr::MassAssignment

  attr_accessor :params, :period

  def initialize(options = {})
    super(options)

    @period = params[:period]  if params
  end

  def reports_for_main_page
    PhotoreportDecorator.decorate searcher.group(:imageable_id_str).groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def total_reports_count
    searcher.group(:imageable_id_str).total
  end

  def weekly_reports_count
    searcher.weekly.group(:imageable_id_str).total
  end

  def monthly_reports_count
    searcher.monthly.group(:imageable_id_str).total
  end

  def page
    params[:page] || 1
  end

  def raw_collection
    search =
      case period
      when 'all'
        searcher.group(:imageable_id_str)
      when 'month'
        searcher.monthly.group(:imageable_id_str)
      when 'week'
        searcher.weekly.group(:imageable_id_str)
      end

    search.groups.map(&:value).map { |id| Affiche.find id  }
  end

  def collection
    PhotoreportDecorator.decorate raw_collection
  end

  private

  def searcher
    HasSearcher.searcher(:photoreport)
  end
end
