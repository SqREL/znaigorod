# encoding: utf-8

class AfficheScheduleDecorator < ApplicationDecorator
  decorates :affiche_schedule

  def days
    from_date = Time.zone.today.beginning_of_week
    to_date = Time.zone.today.end_of_week
    to_date = affiche_schedule.ends_on if affiche_schedule.ends_on < to_date
    {}.tap do |schedule|
      (from_date..to_date).each do |date|
        schedule[wday_with_date(date)] = work_time(date)
      end
    end
  end

  def work_time(date)
    res = ""
    if affiche_schedule.holidays.include? date.wday
      res = "Выходной"
    else
      res = "#{I18n.l(affiche_schedule.starts_at, :format => '%H:%M')}&ndash;#{I18n.l(affiche_schedule.ends_at, :format => '%H:%M')}".html_safe
    end
    h.content_tag(:p, res)
  end

  def wday_with_date(date)
    h.content_tag :p, h.content_tag(:span,  I18n.l(date, :format => '%a')) + h.content_tag(:span, I18n.l(date, :format => '%e %B'))
  end

  def human_price
    humanize_price(affiche_schedule.price_min, affiche_schedule.price_max)
  end
end
