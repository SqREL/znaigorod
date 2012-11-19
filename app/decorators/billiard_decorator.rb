# encoding: utf-8

class BilliardDecorator < SuborganizationDecorator
  decorates :billiard

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    content = "<tr>" +
              "<th colspan='2'>Бильярдные столы</th>"
              "</tr>"
    pool_tables.group_by(&:kind).each do |kind, pool_tables|
      content << "<tr>"
      content << h.content_tag(:td, kind, class: "title", colspan: 2)
      content << "</tr>\n"
      pool_tables.each do |pool_table|
        content << "<tr>"
        content << h.content_tag(:td, "#{pool_table.size} футов, #{pool_table.count}")
        content << h.content_tag(:td, prices_table(pool_table))
        content << "</tr>\n"
      end
    end
    h.content_tag(:table, content.html_safe, class: :services_attributes) + characteristics_by_type("features offers")
  end

  def prices_table(pool_table)
    content = ""
    grouped_prices = pool_table.pool_table_prices.group_by(&:day)
    organization.schedules.each do |schedule|
      day = h.content_tag(:div, schedule.short_human_day, class: :dow)
      schedule_content = if schedule.holiday?
        h.content_tag(:div, "Выходной".hyphenate, class: :string)
      elsif grouped_prices[schedule.day] == nil
        h.content_tag(:div, "Цена не указана".hyphenate, class: :string)
      else
        intervals_html = ""
        grouped_prices[schedule.day].each do |interval|
          intervals_html << h.content_tag(:div, I18n.l(interval.from, :format => "%H:%M"), class: :from)
          intervals_html << h.content_tag(:div, I18n.l(interval.to, :format => "%H:%M"), class: :from)
          intervals_html << h.content_tag(:div, "#{interval.price} руб.", class: :price)
        end
        intervals_html.html_safe
      end
      content << h.content_tag(:li, (day + schedule_content).html_safe, class: I18n.l(Date.today, :format => '%a') == schedule.short_human_day ? 'today' : nil)
    end
    h.content_tag(:ul, content.html_safe, class: :schedule)
  end

end
