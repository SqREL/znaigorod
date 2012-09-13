# encoding: utf-8

class PhotoreportDecorator < AfficheDecorator
  decorates :affiche

  def date
    h.l affiche.images.first.created_at, :format => '%e %B'
  end

  def link(anchor = nil)
    truncated_link(77, anchor)
  end

  def main_images(anchor = nil)
    result = ""
    affiche.images.limit(4).reverse.each do |image|
      result += h.link_to image_tag(image.url, 220, 220, image.description, false), kind_affiche_path(anchor: anchor)
    end
    h.raw result
  end

  def images_count
    affiche.images.count
  end

end
