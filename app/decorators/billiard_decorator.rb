# encoding: utf-8

class BilliardDecorator < SuborganizationDecorator
  decorates :billiard

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    content = ""

    pool_tables.group_by(&:kind).each do |kind, pool_tables|
      content << h.content_tag(:li, kind, class: "title")
      pool_tables.each do |pool_table|
        content << h.content_tag(:li, pool_table.count)
        content << h.content_tag(:li, pool_table.size)

        pool_table.pool_table_prices.each do |pool_table_price|
          content << h.content_tag(:p, pool_table_price)
        end
      end
      content << "\n"
    end
    h.content_tag(:ul, content.html_safe) + characteristics_by_type("features offers")
  end

end
