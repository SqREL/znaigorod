# encoding: utf-8

class PhotoreportDecorator < AfficheDecorator
  decorates :affiche

  def date
    h.l affiche.images.first.created_at, :format => '%e %B'
  end

  def link
    truncated_link(77)
  end

  def main_images
    result = ""
    affiche.images.limit(4).reverse.each do |image|
      result += h.link_to image_tag(image.url, 220, 220, image.description, false), kind_affiche_path
    end
    h.raw result
  end

  def images_count
    affiche.images.count
  end

end
