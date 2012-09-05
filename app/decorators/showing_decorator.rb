# encoding: utf-8

class ShowingDecorator < ApplicationDecorator
  decorates :showing

  def human_when
    if showing.ends_at.nil?
      date = today? ? "Сегодня" : I18n.l(showing.starts_at, :format => '%e %B').squish
      date += " в #{I18n.l(showing.starts_at, :format => '%H:%M')}" if showing.starts_at.beginning_of_day != showing.starts_at
      return date
    else
      from_time = showing.starts_at.beginning_of_day == showing.starts_at ? "" : I18n.l(showing.starts_at, :format => '%H:%M')
      to_time = showing.ends_at.end_of_day == showing.ends_at ? "" : I18n.l(showing.ends_at, :format => '%H:%M')
      if showing.starts_at.to_date == showing.ends_at.to_date
        date = today? ? "Сегодня" : I18n.l(showing.starts_at, :format => '%e %B').squish
        date += " с #{from_time} до #{to_time}"
        return date
      else
        return "#{I18n.l(showing.starts_at, :format => '%e %B').squish} #{from_time} - #{I18n.l(showing.ends_at, :format => '%e %B').squish} #{to_time}"
      end
    end
  end

  def human_price
    return "стоимость не указана" if showing.price_min.nil? && showing.price_max.nil?
    return "бесплатно" if showing.price_min == 0 && (showing.price_max.nil? || showing.price_max == 0)
    return "#{showing.price_min} руб." if showing.price_min > 0 && (showing.price_max.nil? || showing.price_max == 0)
    return "#{showing.price_min} - #{showing.price_max} руб." if showing.price_min > 0 && showing.price_max > 0
    return "бесплатно - #{showing.price_max} руб." if showing.price_min == 0 && showing.price_max > 0
  end

  def today?
    showing.starts_at >= DateTime.now.beginning_of_day && showing.starts_at <= DateTime.now.end_of_day
  end
end
