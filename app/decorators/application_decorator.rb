# encoding: utf-8

class ApplicationDecorator < Draper::Base

  def resized_image_url(url, width, height, crop = true)
    return "" if url.blank?
    image_url, image_id, image_width, image_height, image_crop, image_filename =
      url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

    image_crop = crop ? '!n' : ''

    "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
  end

  def image_tag(url, width, height, title, crop = true)
    options = {}
    options.merge!(title: title, alt: title) if title.present?
    h.image_tag(resized_image_url(url, width, height, crop), options)
  end

  def humanize_price(price_min, price_max)
    return "стоимость не указана".hyphenate if price_min.nil?
    return "бесплатно".hyphenate if price_min == 0 && (price_max.nil? || price_max == 0)
    return "#{price_min} руб.".hyphenate if price_min > 0 && ((price_max.nil? || price_max == 0) || price_max == price_min)
    return "#{price_min} &ndash; #{price_max} руб.".hyphenate.html_safe if price_min > 0 && price_max > 0
    return "бесплатно &ndash; #{price_max} руб.".hyphenate.html_safe if price_min == 0 && price_max > 0
  end

end
