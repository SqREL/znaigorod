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
        content << h.content_tag(:td, "Размер стола: #{pool_table.size} футов")
        content << h.content_tag(:td, "Количество столов: #{pool_table.count}")
        content << "</tr>\n"
        pool_table.pool_table_prices.each do |pool_table_price|
          content << "<tr>"
          content << h.content_tag(:td, pool_table_price, colspan: 2)
          content << "</tr>\n"
        end
      end
    end
    h.content_tag(:table, content.html_safe, class: :services_attributes) + characteristics_by_type("features offers")
  end

end
