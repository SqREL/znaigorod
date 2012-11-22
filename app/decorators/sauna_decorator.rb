# encoding: utf-8

class SaunaDecorator < SuborganizationDecorator
  decorates :sauna

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    content = ""
    %w[sauna_accessory sauna_broom sauna_alcohol sauna_oil sauna_massage sauna_child_stuff sauna_stuff].each do |model_name|
      content << sauna_model_decorate(model_name)
    end
    content << sauna_halls_decorate
    content.html_safe
  end

  def sauna_model_decorate(model_name)
    content = ""
    model = sauna.send(model_name)
    if model.present?
      li = ""
      model.class.accessible_attributes.each do |field|
        li << attribute_decorate(model, field)
      end
      content << h.content_tag(:ul, li.html_safe) if li.present?
    end
    content
  end

  def attribute_decorate(model, field)
    return "" unless model.respond_to?(field)
    case value = model.send(field)
    when Fixnum
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}", count: value)
    when TrueClass
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}.true")
    when FalseClass
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}.false")
    when NilClass
      ""
    end
  end

  def sauna_halls_decorate
    content = ""
    sauna.sauna_halls.each do |sauna_hall|
      content << "<tr>"
      content << h.content_tag(:td, sauna_hall.title, class: :title)
      content << "</tr>"
      content << "<tr>"
      content << "<td>"
      %w[sauna_hall_capacity].each do |model_name|
        content << sauna_hall_model_decorate(sauna_hall, model_name)
      end
      content << "</td>"
      content << "</tr>"
    end
    content = h.content_tag(:table, content.html_safe, class: :services_attributes) if content.present?
    content
  end

  def sauna_hall_model_decorate(sauna_hall, model_name)
    content = ""
    model = sauna_hall.send(model_name)
    if model.present?
      li = ""
      model.class.accessible_attributes.each do |field|
        li << attribute_decorate(model, field)
      end
      content << h.content_tag(:ul, li.html_safe) if li.present?
    end
    content
  end

end
