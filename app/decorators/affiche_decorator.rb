class AfficheDecorator < ApplicationDecorator

  decorates :affiche

  def link
    trancated_link(45)
  end

  def link_with_full_title
      h.link_to hyphenate(affiche.title), h.affiche_path(affiche), :title => affiche.title
  end

  def place
    places = affiche.showings.map { |showing| showing.organization ? showing.organization : showing.place  }.uniq
    max_lenght = 45
    place_output = ""
    places.each_with_index do |place, index|
      place_title = place.is_a?(Organization) ? place.title : place
      place_title.gsub!(/,.*/, '')
      place_link_title = place_title if place_title.size > max_lenght
      place_title = place_title.truncate(max_lenght, :separator => ' ')
      max_lenght -= place_title.size
      if place.is_a?(Organization)
        place_output += h.link_to hyphenate(place_title), h.organization_path(place), :title => place_link_title
      else
        place_output += place_link_title.blank? ? hyphenate(place_title) : h.content_tag(:abbr, hyphenate(place_title), :title => place_link_title)
      end
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    h.raw place_output
  end

  def main_page_poster
    h.link_to image_tag(affiche.poster_url, 200, 268, affiche.title), h.affiche_path(affiche)
  end

  def list_poster
    h.link_to image_tag(affiche.poster_url, 180, 242, affiche.title), h.affiche_path(affiche)
  end

  private

    def trancated_link(length)
      link_title = affiche.title if affiche.title.size > length
      h.link_to hyphenate(affiche.title.truncate(length, :separator => ' ')), h.affiche_path(affiche), :title => link_title
    end

end
