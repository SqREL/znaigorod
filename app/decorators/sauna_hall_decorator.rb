# encoding: utf-8

class SaunaHallDecorator < ApplicationDecorator
  decorates :sauna_hall

  def title
    sauna_hall.title? ? sauna_hall.title : "Основной зал"
  end

  def price
    min_price = sauna_hall_schedules.minimum(:price)
    max_price = sauna_hall_schedules.maximum(:price)
    return min_price if min_price == max_price
    "#{min_price} - #{max_price}"
  end

  def schedule
    #grouped_schedule = {}
    #sauna_hall_schedules.map(&:price).uniq.each do |price|
      #grouped
    #end
    sauna_hall_schedules.group_by(&:price).each do |price, schedules|
    end
  end
end
