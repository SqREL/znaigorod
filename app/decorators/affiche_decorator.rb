class AfficheDecorator < ApplicationDecorator
  decorates :affiche

  def link
    link_title = affiche.title if affiche.title.size > 45
    h.link_to hyphenate(affiche.title.truncate(45, :separator => ' ')), h.affiche_path(affiche), :title => link_title
  end

  def place
    places = affiche.showings.map(&:place).uniq
    max_lenght = 45
    place_output = ""
    places.each_with_index do |place, index|
      place_title = place.is_a?(Organization) ? place.title : place
      place_title.gsub!(/,.*/, '')
      place_link_title = place_title if place_title.size > max_lenght
      place_title = place_title.truncate(max_lenght, :separator => ' ')
      max_lenght -= place_title.size
      place_output += place_link_title.blank? ? place_title : h.content_tag(:abbr, hyphenate(place_title), :title => place_link_title)
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    h.raw place_output
  end

  def poster
    h.link_to h.image_tag_for(affiche.poster_url, 200, 268), h.affiche_path(affiche)
  end

end
