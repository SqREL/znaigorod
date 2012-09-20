# encoding: utf-8

class Photogallery
  include Rails.application.routes.url_helpers

  attr_accessor :period, :query

  def initialize(params = {})
    @period = params[:period] || 'all'
    @query = params[:query] || ''
  end

  def categories
    query_to_hash['categories'] || []
  end

  def all_categories?
    categories.empty?
  end

  def tags
    query_to_hash['tags'] || []
  end

  def main_menu_link
    Link.new title: 'Фотогалереи', url: photogalleries_path(period: 'all')
  end

  def reports_for_main_page
    PhotoreportDecorator.decorate total_groups.groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def period_links
    [].tap do |links|
      links << Link.new(title: "#{I18n.t('photoreport_periods.weekly')} (#{week_groups_count})", url: photogalleries_path(period: 'week'))
      links << Link.new(title: "#{I18n.t('photoreport_periods.monthly')} (#{month_groups_count})", url: photogalleries_path(period: 'month'))
      links << Link.new(title: "#{I18n.t('photoreport_periods.total')} (#{total_groups_count})", url: photogalleries_path(period: 'all'))
    end
  end

  def collection
    PhotoreportDecorator.decorate raw_collection
  end

  private

  def key_words
    %w[categories tags]
  end

  def query_to_hash
    {}.tap do |hash|
      key_word = ''

      query.split('/').each do |word|
        key_word = word and hash[word] ||= [] and next if key_words.include?(word)
        hash[key_word] << word
      end
    end
  end

  def searcher
    HasSearcher.searcher(:photoreport)
  end

  def total_groups
    searcher.group(:imageable_id_str)
  end

  def week_groups
    searcher.weekly.group(:imageable_id_str)
  end

  def month_groups
    searcher.monthly.group(:imageable_id_str)
  end

  def total_groups_count
    total_groups.total
  end

  def week_groups_count
    week_groups.total
  end

  def month_groups_count
    month_groups.total
  end

  def raw_collection
    groups = case period
             when 'all'
               total_groups
             when 'week'
               week_groups
             when 'month'
               month_groups
             end
    groups.groups.map(&:value).map { |id| Affiche.find(id) }
  end
end
