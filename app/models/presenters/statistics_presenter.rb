class StatisticsPresenter
  def affiches_with_page_views
    Affiche.unscoped.where('yandex_metrika_page_views IS NOT NULL').order('yandex_metrika_page_views DESC').
      where('created_at >= ?', from_date).
      limit(10).
      map { |a|
      AfficheDecorator.new(a)
    }
  end

  def affiches_with_likes
    Affiche.unscoped.where('vkontakte_likes IS NOT NULL').order('vkontakte_likes DESC').
      where('created_at >= ?', from_date).
      limit(10).
      map { |a|
      AfficheDecorator.new(a)
    }
  end

  def from_date
    1.month.ago
  end
end
