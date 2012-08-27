class ApplicationDecorator < Draper::Base

  def hyphenate(text)
    hh = Text::Hyphen.new(:language => 'ru', :left => 2, :right => 2)
    text.squish.split(" ").map { |word| hh.visualize(word, "\u00AD") }.join(" ")
  end


  def resized_image_url(url, width, height, crop = true)
    image_url, image_id, image_width, image_height, image_crop, image_filename =
      url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

    image_crop = crop ? '!' : ''

    "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
  end

  def image_tag(url, width, height, title, crop = true)
    h.image_tag(resized_image_url(url, width, height, crop), :title => title, :alt => title)
  end

end
