# encoding: utf-8

class String
  def as_html
    require 'redcloth'
    require 'gilenson'
    Gilenson::RedClothExtra.new(self).to_html.html_safe
  end

  def as_text
    require 'nokogiri'
    Nokogiri::HTML(self.gsub(/>/, '> ')).text.squish
  end

  def without_table
    self.gsub(/<table>.*<\/table>/m, '')
  end

  def hyphenate
    require 'text-hyphen'
    hh = Text::Hyphen.new(:language => 'ru', :left => 2, :right => 2)
    self.split(" ").map { |word| hh.visualize(word, "\u00AD") }.join(" ")
  end

  def truncated
    self.truncate(230, :separator => ' ', :omission => '…')
  end

  def excerpt
    self.without_table.as_text.truncated
  end

  def text_gilensize
    self.gilensize(:html => false, :raw_output => true).squish
  end
end
