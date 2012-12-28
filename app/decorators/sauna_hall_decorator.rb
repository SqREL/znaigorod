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
    grouped_schedule.each do |price, schedules|
      schedules.each do |schedule_time, days|
        content << h.content_tag(:li, "<strong>#{schedule_day_names(days)} #{schedule_time}:</strong> #{price}".html_safe)
      end
    end
    h.content_tag(:div, "расписание", class: "work_schedule") + h.content_tag(:ul, content.html_safe, class: :more_schedule)
  end
end
