# encoding: utf-8

class AfficheDecorator < ApplicationDecorator
  include AutoHtmlFor
  decorates :affiche

  delegate :distribution_starts_on, :distribution_ends_on, :distribution_starts_on?, :distribution_ends_on?, :to => :affiche
  attr_accessor :showings

  def initialize(affiche, showings = nil)
    super
    @showings = showings ? ShowingDecorator.decorate(showings) : ShowingDecorator.decorate(affiche.showings.actual)
  end

  def main_page_link
    truncated_link(45)
  end

  def kind
    affiche.class.name.downcase
  end

  auto_html_for :trailer_code do
    youtube(:width => 740, :height => 450)
  end

  def kind_affiche_path(options = {})
    h.send "#{kind}_path", affiche, options
  end

  def kind_affiche_url(options = {})
    h.send "#{kind}_url", affiche, options
  end

  def kind_affiche_photogallery_path(options = {})
    h.send "#{kind}_photogallery_path", affiche, options
  end

  def kind_affiche_trailer_path(options = {})
    h.send "#{kind}_trailer_path", affiche, options
  end

  def all_affiches_link
    h.link_to "Все #{human_kind.mb_chars.downcase} (#{counter.all})",
              h.affiches_path(kind: kind.pluralize, period: :all)
  end

  def link
    h.link_to affiche.title.gilensize.html_safe, kind_affiche_path
  end

  def more_link
    h.link_to "Подробнее...", kind_affiche_path, :title => affiche.title
  end

  def schedule
    AfficheScheduleDecorator.decorate affiche.affiche_schedule
  end

  def tabs
    [].tap do |links|
      links << h.content_tag(:li, h.link_to("Описание", "#info"))
      links << h.content_tag(:li, h.link_to(affiche.is_a?(Movie) ? "Кадры" : "Фотографии", "#photogallery", "data-link" => kind_affiche_photogallery_path), :class => affiche.has_images? ? nil : 'disabled')
      links << h.content_tag(:li, h.link_to(affiche.is_a?(Movie) ? "Трейлер" : "Видео", "#trailer", "data-link" => kind_affiche_trailer_path), :class => affiche.trailer_code? ? nil : 'disabled')
    end
  end

  def main_page_place
    max_lenght = 45
    place_output = ""
    places.each_with_index do |place, index|
      place_title = place.organization ? place.organization.title : place.title
      place_link_title = place_title.dup
      place_title = place_title.gsub(/,.*/, '')
      place_title = place_title.truncate(max_lenght, :separator => ' ')
      max_lenght -= place_title.size
      if place.organization
        place_output += h.link_to h.hyphenate(place_title).gilensize.html_safe, h.organization_path(place.organization), :title => place_link_title.gilensize.gsub(/<\/?\w+.*?>/m, ' ').html_safe
      else
        place_output += place_link_title.blank? ? h.hyphenate(place_title).gilensize.html_safe : h.content_tag(:abbr, h.hyphenate(place_title).gilensize.html_safe, :title => place_link_title.gilensize.gsub(/<\/?\w+.*?>/m, ' ').html_safe)
      end
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    h.raw place_output
  end

  def places
    [].tap do |array|
      showings.map { |showing| showing.organization ? showing.organization : showing.place }.uniq.each do |place|
        array << (place.is_a?(Organization) ? PlaceDecorator.new(:organization => place) : PlaceDecorator.new(:title => place,
                                                                                                              :latitude => affiche.showings.where(:place => place).first.latitude,
                                                                                                              :longitude => affiche.showings.where(:place => place).first.longitude))
      end
    end
  end

  def truncated_description
    h.hyphenate(html_description.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, ' ').squish.truncate(230, :separator => ' ').gilensize).html_safe
  end

  def html_description
    RedCloth.new(affiche.description).to_html.gsub(/&#8220;|&#8221;/, '"').gilensize.html_safe
  end

  def main_page_poster
    poster_with_link affiche, 200, 268
  end

  def tags_for_vk
    desc = html_description.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, ' ').squish.truncate(350, :separator => ' ').html_safe
    image = resized_image_url(poster_url, 180, 242, false)
    res = ""
    res << "<meta name='description' content='#{desc}' />\n"
    res << "<meta property='og:description' content='#{desc}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('site_title')}' />\n"
    res << "<meta property='og:title' content='#{human_kind}: #{title.gilensize.gsub(/<\/?\w+.*?>/m, " ").gsub("&#160;", " ").gsub(" ,", ",").squish.html_safe}' />\n"
    res << "<meta property='og:url' content='#{kind_affiche_url}' />\n"
    res << "<meta property='og:image' content='#{image}' />\n"
    res << "<meta name='image' content='#{image}' />\n"
    res << "<link rel='image_src' href='#{image}' />\n"
    res.html_safe
  end

  def list_poster
    poster_with_link affiche, 180, 242
  end

  def item_poster
    h.link_to poster(affiche, 180, 242), affiche.poster_url
  end

  def more_like_this_poster
    poster_with_link affiche, 150, 202
  end

  def affiche_distribution?
    affiche.distribution_starts_on?
  end

  def human_when
    if showings.any?
      return "Постоянная экспозиция" if affiche.constant?
      return human_distribution if affiche.distribution_starts_on?
      return showings.first.human_when
    else
      last_showing = ShowingDecorator.new(affiche.showings.last)
      case affiche.class.name
      when 'Movie'
        if affiche_distribution?
          return "Было в прокате до #{last_showing.e_B(last_showing.starts_at)}"
        else
          return "Последний показ был #{last_showing.e_B(last_showing.starts_at)}"
        end
      when 'Exhibition'
        return "Выставка закончилась #{last_showing.e_B(last_showing.starts_at)}"
      else
        return "Было #{last_showing.e_B(last_showing.starts_at)}"
      end
    end
  end

  def human_price
    humanize_price(showings.map(&:price_min).uniq.compact.min, showings.map(&:price_max).uniq.compact.max)
  end

  def when_with_price
    if showings.any?
      h.content_tag :p, h.content_tag(:span, human_when, :class => :when ) + ", " + h.content_tag(:span, human_price, :class => :price).html_safe
    else
      h.content_tag :p, h.content_tag(:span, human_when, :class => :when )
    end
  end

  def human_distribution
    return nil unless distribution_starts_on?
    if distribution_starts_on? && distribution_ends_on?
      return "С #{distribution_starts_on.day} до #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish if  distribution_starts_on.month == distribution_ends_on.month
      return "С #{I18n.l(distribution_starts_on, :format => '%e %B')} до #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish
    end
    return "С #{I18n.l(distribution_starts_on, :format => '%e %B')}".squish
  end

  def kind
    affiche.class.name.downcase
  end

  def pluralized_kind
    kind.pluralize
  end

  def human_kind
    I18n.t("activerecord.models.#{kind}")
  end

  def other_showings
    return [] if affiche.is_a?(Movie)
    if affiche_distribution?
      return affiche.showings.where("starts_at >= ?", showings.first.starts_at)
    else
      return affiche.showings.where("starts_at > ?", showings.first.starts_at) unless showings.blank?
      []
    end
  end

  def first_other_showing_today?
    ShowingDecorator.decorate(other_showings.first).today?
  end

  def other_showings_size
    other_showings.count - 2
  end

  def html_many_other_showings
    return "" unless other_showings_size > 0
    ("&nbsp;" + h.link_to("и еще #{other_showings_size}", kind_affiche_path(:anchor => "showings"))).gilensize.html_safe
  end

  def html_other_showings
    ((ShowingDecorator.decorate(other_showings[0..1]).map(&:html_other_showing)).compact.join(", <br />") + html_many_other_showings).html_safe
  end

  def distribution_movie?
    affiche.is_a?(Movie) && affiche_distribution?
  end

  def distribution_movie_nearlest_grouped_showings
    showings.group_by(&:starts_on).first.second.select(&:actual?).group_by(&:place)
  end

  def distribution_movie_grouped_showings
    {}.tap do |hash|
      showings.group_by(&:starts_on).each do |date, showings|
        hash[date] = showings.select(&:actual?).group_by(&:place)
      end
    end
  end

  def distribution_movie_schedule_date
    "Ближайшие сеансы #{showings.first.human_date.mb_chars.downcase}"
  end

  def similar_affiches
    searcher.more_like_this(affiche).limit(2).results.map { |a| AfficheDecorator.new a }
  end

  def similar_affiches_with_images
    searcher.more_like_this(affiche).with_images.limit(2).results.map { |a| AfficheDecorator.new a }
  end

  def trailer
    return "" if trailer_code.blank?
    trailer_code.html_safe
  end

  def scheduled_showings?
    !affiche.affiche_schedule.nil? && affiche.is_a?(Exhibition)
  end

  private

  def truncated_link(length, anchor = nil)
    h.link_to h.hyphenate(affiche.title.truncate(length, :separator => ' ')).gilensize.html_safe, kind_affiche_path(anchor: anchor), :title => affiche.title
  end

  def in_one_day?
    distribution_starts_on == distribution_ends_on
  end

  def poster_with_link(affiche, width, height)
    h.link_to poster(affiche, width, height), kind_affiche_path
  end

  def poster(affiche, width, height)
    image_tag(affiche.poster_url, width, height, affiche.title.gilensize.gsub(/<\/?\w+.*?>/m, '').html_safe)
  end

  def searcher
    HasSearcher.searcher(:similar_affiches)
  end

  def counter
    Counter.new(:kind => kind)
  end
end
