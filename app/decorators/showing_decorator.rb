# encoding: utf-8

class ShowingDecorator < ApplicationDecorator
  decorates :showing

  delegate :starts_at, :ends_at, :ends_at?, :to => :showing

  def human_date
    today? ? 'Сегодня' : e_B(starts_at)
  end

  def human_when
    unless ends_at?
      date = human_date
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
        return "#{starts_at.day} &ndash; #{e_B(ends_at)}".html_safe if in_one_month? && starts_at_only_date? && ends_at_only_date?
        return "#{e_B(starts_at)} &ndash; #{e_B(ends_at)}".html_safe if starts_at_only_date? && ends_at_only_date?
        return "#{e_B(starts_at)} #{from_time} &ndash; #{e_B(ends_at)} #{to_time}".html_safe
      end
    end
  end

  def human_time_starts_at
    H_M(showing.starts_at)
  end

  def place_decorator
    return PlaceDecorator.new(:organization => showing.organization) if showing.organization
    PlaceDecorator.new(:title => showing.place, :latitude => showing.latitude, :longitude => showing.longitude)
  end

  def human_price
    humanize_price(showing.price_min, showing.price_max)
  end

  def html_other_showing
    h.content_tag(:strong, human_when) + " (#{human_price})".html_safe
  end

  def today?
    starts_at >= Time.zone.now.beginning_of_day && starts_at <= Time.zone.now.end_of_day
  end

  def actual?
    starts_at >= Time.zone.now
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
