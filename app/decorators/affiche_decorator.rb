# encoding: utf-8

class AfficheDecorator < ApplicationDecorator
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

  def link
    h.link_to affiche.title.gilensize.html_safe, h.affiche_path(affiche)
  end

  def more_link
    h.link_to "Подробнее...", h.affiche_path(affiche), :title => affiche.title
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
        place_output += h.link_to hyphenate(place_title), h.organization_path(place.organization), :title => place_link_title
      else
        place_output += place_link_title.blank? ? hyphenate(place_title) : h.content_tag(:abbr, hyphenate(place_title), :title => place_link_title)
      end
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    h.raw place_output
  end

  def places
    [].tap do |array|
      showings.map { |showing| showing.organization ? showing.organization : [showing.place, showing.latitude, showing.longitude] }.uniq.each do |place|
        array << (place.is_a?(Organization) ? PlaceDecorator.new(:organization => place) : PlaceDecorator.new(:title => place[0], :latitude => place[1], :longitude => place[2]))
      end
    end
  end

  def truncated_description
    hyphenate(html_description.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, ' ').squish.truncate(230, :separator => ' ').gilensize).html_safe
  end

  def html_description
    RedCloth.new(affiche.description).to_html.gsub(/&#8220;|&#8221;/, '"').gilensize.html_safe
  end

  def main_page_poster
    poster affiche, 200, 268
  end

  def list_poster
    poster affiche, 180, 242
  end

  def affiche_distribution?
    affiche.distribution_starts_on?
  end

  def human_when
    return human_distribution if affiche.distribution_starts_on?
    return showings.first.human_when
  end

  def human_price
    humanize_price(showings.map(&:price_min).uniq.compact.min, showings.map(&:price_max).uniq.compact.max)
  end

  def when_with_price
    h.content_tag :p, h.content_tag(:span, human_when, :class => :when ) + ", " + h.content_tag(:span, human_price, :class => :cost)
    end

  def human_distribution
    return nil unless distribution_starts_on?

    return "С #{distribution_starts_on.day} до #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish if distribution_starts_on? && distribution_ends_on?

    return "С #{I18n.l(distribution_starts_on, :format => '%e %B')}".squish
  end

  def other_showings
    return [] if affiche.is_a?(Movie)
    if affiche_distribution?
      return affiche.showings.where("starts_at >= ?", showings.first.starts_at)
    else
      return affiche.showings.where("starts_at > ?", showings.first.starts_at)
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
    ("&nbsp;" + h.link_to("и еще #{other_showings_size}", h.affiche_path(affiche, :anchor => "showings"))).gilensize.html_safe
  end

  def html_other_showings
    ((ShowingDecorator.decorate(other_showings[0..1]).map(&:html_other_showing)).compact.join(", <br />") + html_many_other_showings).html_safe
  end

  private

  def truncated_link(length)
    h.link_to hyphenate(affiche.title.truncate(length, :separator => ' ')).gilensize.html_safe, h.affiche_path(affiche), :title => affiche.title
  end

  def in_one_day?
    distribution_starts_on == distribution_ends_on
  end

  def poster(affiche, width, height)
    h.link_to image_tag(affiche.poster_url, width, height, affiche.title.gilensize.gsub(/<\/?\w+.*?>/m, '').html_safe), h.affiche_path(affiche)
  end

end
