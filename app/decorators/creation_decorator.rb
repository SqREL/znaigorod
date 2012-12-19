# encoding: utf-8

class CreationDecorator < SuborganizationDecorator
  decorates :creation

  def characteristics_on_list
    characteristics_by_type("features")
  end

  def characteristics_on_show
    return "" if services.filled.empty?
    content = "<tr>" +
              "<th>Предложения</th>" +
              "<th>Возраст</th>" +
              "</tr>\n"

    services.filled.group_by(&:category).each do |category, services|
      content << "<tr>"
      content << h.content_tag(:td, category, class: "title", colspan: 2)
      content << "</tr>\n"
      services.each do |service|
        content << "<tr>"
        content << h.content_tag(:td, h.raw("#{h.content_tag(:p, service.title, class: :offer)}\n#{htmlize_text(service.description)}"))
        content << h.content_tag(:td, service.age)
        content << "</tr>\n"
      end
    end
    h.content_tag(:table, content.html_safe, class: :services_attributes) + characteristics_by_type("features")
  end
end
