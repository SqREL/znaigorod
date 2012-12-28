# encoding: utf-8

class PoolTableDecorator < ApplicationDecorator
  decorates :pool_table

  def ft
    "#{size} ft"
  end

  def price
    min_price = pool_table_prices.minimum(:price)
    max_price = pool_table_prices.maximum(:price)
    humanize_price(min_price, max_price)
  end

  def schedule
    grouped_schedule = {}
    pool_table_prices.group_by(&:price).each do |price, schedules|
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
end