# encoding: utf-8

class SportDecorator < SuborganizationDecorator
  decorates :sport

  def characteristics_on_list
    characteristics_by_type("features")
  end

  def characteristics_on_show

    content = "<tr>" +
              "<th>Предложения</th>" +
              "<th>Возраст</th>" +
              "</tr>\n"

    services.group_by(&:category).each do |category, services|
      content << "<tr>"
      content << h.content_tag(:td, category, class: "title", colspan: 2)
      content << "</tr>\n"
      services.each do |service|
        content << "<tr>"
        content << h.content_tag(:td, h.raw("#{h.content_tag(:p, service.title, class: :offer)}\n#{service.description.as_html}"))
        content << h.content_tag(:td, service.age)
        content << "</tr>\n"
      end
    end
    h.content_tag(:table, content.html_safe, class: :services_attributes) + characteristics_by_type("features")
  end

end
