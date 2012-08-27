# encoding: utf-8

class PhotoreportDecorator < AfficheDecorator
  decorates :affiche

  def date
    h.l affiche.images.first.created_at, :format => '%d %B'
  end

  def link
    trancated_link(77)
  end

  def main_images
    result = ""
    affiche.images.limit(4).each do |image|
      result += h.link_to h.image_tag_for(image.url, 220, 220, false), h.affiche_path(affiche)
    end
    h.raw result
  end

  def images_count
    affiche.images.count
  end

end
