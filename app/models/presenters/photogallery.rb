# encoding: utf-8

class Photogallery
  include ActiveAttr::MassAssignment
  include ActionView::Helpers#::UrlHelper
  include Rails.application.routes.url_helpers

  attr_accessor :params, :period

  def initialize(options = {})
    super(options)

    @period = params[:period]  if params
  end

  def reports_for_main_page
    PhotoreportDecorator.decorate searcher.group(:imageable_id_str).groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def menu_link
    link_to 'Фотогалереи', photogalleries_path(category: 'all')
  end

  def main_page_links
    [].tap do |links|
      links << link_to("#{t('photoreport_periods.weekly')} (#{weekly_reports_count})", photogalleries_path(category: 'all', period: 'week'))
      links << link_to("#{t('photoreport_periods.monthly')} (#{monthly_reports_count})", photogalleries_path(category: 'all', period: 'month'))
      links << link_to("#{t('photoreport_periods.total')} (#{total_reports_count})", photogalleries_path(category: 'all'))
    end
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
