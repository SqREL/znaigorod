# encoding: utf-8

class SaunaHallDecorator < ApplicationDecorator
  decorates :sauna_hall

  def title
    sauna_hall.title? ? sauna_hall.title : "Основной зал"
  end

  def price
    min_price = sauna_hall_schedules.minimum(:price)
    max_price = sauna_hall_schedules.maximum(:price)
    humanize_price(min_price, max_price)
  end

  def schedule
    grouped_schedule = {}
    sauna_hall_schedules.group_by(&:price).each do |price, schedules|
      grouped_schedule[price] = {}
      schedules.each do |schedule|
        daily_schedule = schedule_time(schedule.from, schedule.to)
        grouped_schedule[price][daily_schedule] ||= []
        grouped_schedule[price][daily_schedule] << schedule.day
      end
    end
    content = ""
    printed_days = []
    grouped_schedule.each do |price, schedules|
      schedules.each do |schedule_time, days|
        li = printed_days.eql?(days) ? "<strong>#{schedule_time}:</strong> #{price}" :  "<strong>#{schedule_day_names(days)} #{schedule_time}:</strong> #{price}"
        content << h.content_tag(:li, li.html_safe)
        printed_days = days
      end
    end
    h.content_tag(:div, "расписание", class: "work_schedule") + h.content_tag(:ul, content.html_safe, class: :more_schedule)
  end

  def htmlise_capacity_on_show
    model_decorate("sauna_hall_capacity")
  end

  def model_decorate(model_name)
    content = ""
    model = sauna_hall.send(model_name)
    if model.present?
      li = ""
      model.class.accessible_attributes.each do |field|
        li << attribute_decorate(model, field).html_safe
      end
      content << h.content_tag(:ul, li.html_safe, class: model_name) if li.present?
    end
    content.html_safe
  end

  def attribute_decorate(model, field)
    return "" unless model.respond_to?(field)
    case value = model.send(field)
    when String
      h.content_tag :li, [I18n.t("sauna.#{model.class.name.underscore}.#{field}"), value].join(": ")
    when Fixnum
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}", count: value)
    when TrueClass
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}.true")
    when FalseClass
      return "" if %w[sauna_hall_bath sauna_hall_pool sauna_hall_interior].include?(model.class.name.underscore)
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}.false")
    when NilClass
      ""
    end
  end


  def has_photogallery?
    images.any?
  end
end
