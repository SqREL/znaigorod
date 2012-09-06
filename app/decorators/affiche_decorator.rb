# encoding: utf-8

class AfficheDecorator < ApplicationDecorator
  decorates :affiche

  delegate :distribution_starts_on, :distribution_ends_on, :distribution_starts_on?, :distribution_ends_on?, :to => :affiche
  attr_accessor :showings

  def initialize(affiche, showings = nil)
    super
    @showings ||= affiche.showings.actual
    @showings = ShowingDecorator.decorate(@showings)
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
    h.link_to image_tag(affiche.poster_url, 200, 268, affiche.title.gilensize.html_safe), h.affiche_path(affiche)
  end

  def list_poster
    h.link_to image_tag(affiche.poster_url, 180, 242, affiche.title.gilensize.html_safe), h.affiche_path(affiche)
  end

  def affiche_distribution?
    affiche.distribution_starts_on?
  end

  def human_when
    return human_distribution if affiche.distribution_starts_on?
    return showings.first.human_when
  end

  def human_distribution
    return nil unless distribution_starts_on?

    return "С #{distribution_starts_on.day} до #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish if distribution_starts_on? && distribution_ends_on?

    return "С #{I18n.l(distribution_starts_on, :format => '%e %B')}".squish
  end

  private

  def truncated_link(length)
    h.link_to hyphenate(affiche.title.truncate(length, :separator => ' ')).gilensize.html_safe, h.affiche_path(affiche), :title => affiche.title
  end

  def in_one_day?
    distribution_starts_on == distribution_ends_on
  end

end
