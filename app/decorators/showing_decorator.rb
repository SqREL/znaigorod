# encoding: utf-8

class ShowingDecorator < ApplicationDecorator
  decorates :showing

  def human_when
    date = today? ? "Сегодня" : I18n.l(showing.starts_at, :format => '%e %B').squish
    date += " в #{I18n.l(showing.starts_at, :format => '%H:%M')}" unless showing.starts_at.beginning_of_day == showing.starts_at
    date
  end

  private
  def today?
    showing.starts_at >= DateTime.now.beginning_of_day && showing.starts_at <= DateTime.now.end_of_day
  end
end
