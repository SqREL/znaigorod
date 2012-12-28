# encoding: utf-8

class CreationDecorator < SuborganizationDecorator
  decorates :creation

  def viewable?
    creation.services.filled.any?
  end

  def title
    creation.title? ? creation.title : 'Творческие и развивающие направления'
  end

  def htmlise_title_on_show
    h.content_tag :h1, title, :class => 'creation'
  end

  def htmlise_features_on_show
    h.content_tag(:ul, features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe, :class => 'features')
  end

  def characteristics_on_list
    characteristics_by_type("features")
  end

  def characteristics_on_show
    content = ""
    services.filled.group_by(&:category).each do |category, services|
      content << h.content_tag(:h2, category, class: "title")
      services_content = ""
      services.each do |service|
        info = service.description? ? htmlize_text(service.description) : ''
        title = h.content_tag(:span, service.title, class: 'offer')
        age = h.content_tag(:span, human_age(service.age), class: 'age')
        services_content << h.content_tag(:li, title+info+age)
      end
      content << h.content_tag(:ul, services_content.html_safe, class: 'services')
    end
    h.content_tag(:div, content.html_safe, class: :services_attributes)
  end
end
