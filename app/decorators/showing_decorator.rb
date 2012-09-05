# encoding: utf-8

class ShowingDecorator < ApplicationDecorator
  decorates :showing

  delegate :starts_at, :ends_at, :ends_at?, :to => :showing

  def human_when
    unless ends_at?
      date = today? ? 'Сегодня' : e_B(starts_at)
      date += " в #{H_M(starts_at)}" unless starts_at_only_date?

      return date
    else
      from_time = starts_at_only_date? ? '' : H_M(starts_at)
      to_time = ends_at_only_date? ? '' : H_M(ends_at)

      if in_one_day?
        date = today? ? 'Сегодня' : e_B(starts_at)
        date += " с #{from_time} до #{to_time}"

        return date
      else
        return "#{starts_at.day} - #{e_B(ends_at)}" if in_one_month? && starts_at_only_date? && ends_at_only_date?
        return "#{e_B(starts_at)} - #{e_B(ends_at)}" if starts_at_only_date? && ends_at_only_date?
        return "#{e_B(starts_at)} #{from_time} - #{e_B(ends_at)} #{to_time}"
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
    starts_at >= Time.zone.now.beginning_of_day && starts_at <= Time.zone.now.end_of_day
  end

  def in_one_month?
    starts_at.month == ends_at.month
  end

  def in_one_day?
    starts_at.to_date == ends_at.to_date
  end

  def starts_at_only_date?
    starts_at == starts_at.beginning_of_day
  end

  def ends_at_only_date?
    ends_at == ends_at.end_of_day
  end

  def e_B(date)
    I18n.l(date, :format => '%e %B').squish
  end

  def H_M(date)
    I18n.l(date, :format => '%H:%M')
  end
end
