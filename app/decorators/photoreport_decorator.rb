# encoding: utf-8

class PhotoreportDecorator < AfficheDecorator
  decorates :affiche

  def date
    h.l affiche.images.first.created_at, :format => '%d %B'
  end


  def main_images
    result = ""
    affiche.images.limit(3).each do |image|
      result += h.link_to h.image_tag_for(image.url, 200, 268, false), h.affiche_path(affiche)
    end
    h.raw result
  end

  def images_count
    affiche.images.count
  end
end
