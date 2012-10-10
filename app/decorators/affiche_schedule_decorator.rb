# encoding: utf-8

class AfficheScheduleDecorator < ApplicationDecorator
  decorates :affiche_schedule

  def days
    from_date = Time.zone.today.beginning_of_week
    to_date = Time.zone.today.end_of_week
    to_date = affiche_schedule.ends_on if affiche_schedule.ends_on < to_date
    (from_date..to_date).map do |date|
      li_date_with_worktime(date)
    end
  end

  def work_time(date)
    res = ""
    if affiche_schedule.starts_on > date && affiche_schedule.ends_on > date
      res = h.content_tag(:span, "не работает", class: :weekend)
    elsif affiche_schedule.holidays.include? date.wday
      res = h.content_tag(:span, "выходной", :class => :weekend)
    else
      res << h.content_tag(:span, I18n.l(affiche_schedule.starts_at, :format => '%H:%M'), :class => :begin)
      res << h.content_tag(:span, I18n.l(affiche_schedule.ends_at, :format => '%H:%M'), :class => :end)
    end
    h.content_tag :p, res.html_safe, :class => :work_time_wrapper
  end

  def wday_with_date(date)
    res = ""
    res << h.content_tag(:span,  I18n.l(date, :format => '%a'), :class => :day_of_week)
    res << h.content_tag(:span, I18n.l(date, :format => '%e %B'), :class => :date)
    h.content_tag :p, res.html_safe, :class => :date_wrapper
  end

  def li_date_with_worktime(date)
    li_class = nil
    li_class = 'current' if date == Time.zone.today
    h.content_tag :li, wday_with_date(date) + work_time(date), :class => li_class
  end

  def human_price
    humanize_price(affiche_schedule.price_min, affiche_schedule.price_max)
  end
end
