# encoding: utf-8

class SportDecorator < SuborganizationDecorator
  decorates :sport

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    content = ""
    #content << "\n"
    #self.send(name).each do |value|
    #end
    services.group_by(&:title).each do |title, services|
      content << h.content_tag(:li, title, class: "title")
      services.each do |service|
        content << h.content_tag(:li, service.offer)
        content << h.content_tag(:li, service.feature)
        content << h.content_tag(:li, service.age)
      end
      content << "\n"
    end
    h.content_tag(:ul, content.html_safe) + characteristics_by_type("features offers")
  end

end
