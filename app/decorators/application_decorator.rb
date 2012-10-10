# encoding: utf-8

class ApplicationDecorator < Draper::Base

  def resized_image_url(url, width, height, crop = true)
    return "" if url.blank?
    image_url, image_id, image_width, image_height, image_crop, image_filename =
      url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

    image_crop = crop ? '!' : ''

    "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
  end

  def image_tag(url, width, height, title, crop = true)
    h.image_tag(resized_image_url(url, width, height, crop), :title => title, :alt => title)
  end

  def html_title(text)
    text.gilensize.gsub(' ,', ',').squish.html_safe
  end

  def humanize_price(price_min, price_max)
    return h.hyphenate("стоимость не указана") if price_min.nil? && price_max.nil?
    return h.hyphenate("бесплатно") if price_min == 0 && (price_max.nil? || price_max == 0)
    return h.hyphenate("#{price_min} руб.") if price_min > 0 && ((price_max.nil? || price_max == 0) || price_max == price_min)
    return h.hyphenate("#{price_min} &ndash; #{price_max} руб.").html_safe if price_min > 0 && price_max > 0
    return h.hyphenate("бесплатно &ndash; #{price_max} руб.").html_safe if price_min == 0 && price_max > 0
  end

end
