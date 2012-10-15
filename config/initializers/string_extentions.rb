# encoding: utf-8

class String
  def as_html
    require 'redcloth'
    require 'gilenson'
    Gilenson::RedClothExtra.new(self).to_html.html_safe
  end

  def as_text
    require 'nokogiri'
    Nokogiri::HTML(self.gsub(%r{</?span.*?>}, '').gsub(/>/, '> ')).text.squish
  end

  def without_table
    self.gsub(/<table>.*<\/table>/m, '')
  end

  def hyphenate
    require 'text-hyphen'
    hh = Text::Hyphen.new(:language => 'ru', :left => 2, :right => 2)
    result = self.split(" ").map { |word| hh.visualize(word, "\u00AD") }.join(" ")
    self.html_safe? ? result.html_safe : result
  end

  def truncated(length=230)
    self.truncate(length, :separator => ' ', :omission => '…')
  end

  def excerpt
    self.as_html.without_table.as_text.truncated
  end

  def text_gilensize
    self.gilensize(:html => false, :raw_output => true).gsub(%r{</?.*?>}, '').gsub(/\A[[:space:]]+|[[:space:]]+\Z/, '').squish
  end

  def gilensize_with_html_safe(*args)
    args.empty? ? gilensize_without_html_safe.html_safe : gilensize_without_html_safe(*args)
  end

  alias_method_chain :gilensize, :html_safe

end
