# encoding: utf-8

class SportDecorator < CreationDecorator
  decorates :sport

  def title
    sport.title? ? sport.title : 'Спорт'
  end

  def htmlise_title_on_show
    h.content_tag :h1, title, :class => 'sport'
  end

end
