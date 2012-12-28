# encoding: utf-8

class EntertainmentDecorator < SuborganizationDecorator
  decorates :entertainment

  def viewable?
    entertainment.offers.any? || entertainment.features.any?
  end

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    characteristics_by_type("features offers")
  end

  def title
    entertainment.title? ? meal.title : categories.first
  end

  def htmlise_title_on_show
    h.content_tag :h1, title, :class => I18n.transliterate(categories.first).downcase
  end

  def htmlise_offers_on_show
    h.content_tag(:ul, offers.map {|f| h.content_tag(:li, f)}.join("\n").html_safe, :class => 'offers') if offers.any?
  end

  def htmlise_features_on_show
    h.content_tag(:ul, features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe, :class => 'features') if features.any?
  end

end
