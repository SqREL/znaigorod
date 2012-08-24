class ApplicationDecorator < Draper::Base

  def hyphenate(text)
    hh = Text::Hyphen.new(:language => 'ru', :left => 2, :right => 2)
    text.squish.split(" ").map { |word| hh.visualize(word, "\u00AD") }.join(" ")
  end

end
