# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://znaigorod.ru"

SitemapGenerator::Sitemap.create do

  # Вся афиша
  add affiches_path('affiches', 'all'),         :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
  add affiches_path('affiches', 'weekly'),      :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
  add affiches_path('affiches', 'weekend'),     :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
  add affiches_path('affiches', 'today'),       :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at

  # Фильмы
  add affiches_path('movies', 'all'),           :changefreq => 'daily', :priority => 0.7, :lastmod => Movie.unscoped.last.updated_at
  add affiches_path('movies', 'weekly'),        :changefreq => 'daily', :priority => 0.7, :lastmod => Movie.unscoped.last.updated_at
  add affiches_path('movies', 'weekend'),       :changefreq => 'daily', :priority => 0.7, :lastmod => Movie.unscoped.last.updated_at
  add affiches_path('movies', 'today'),         :changefreq => 'daily', :priority => 0.7, :lastmod => Movie.unscoped.last.updated_at

  # Коцерты
  add affiches_path('concerts', 'all'),         :changefreq => 'daily', :priority => 0.7, :lastmod => Concert.unscoped.last.updated_at
  add affiches_path('concerts', 'weekly'),      :changefreq => 'daily', :priority => 0.7, :lastmod => Concert.unscoped.last.updated_at
  add affiches_path('concerts', 'weekend'),     :changefreq => 'daily', :priority => 0.7, :lastmod => Concert.unscoped.last.updated_at
  add affiches_path('concerts', 'today'),       :changefreq => 'daily', :priority => 0.7, :lastmod => Concert.unscoped.last.updated_at

  # Вечеринки
  add affiches_path('parties', 'all'),          :changefreq => 'daily', :priority => 0.7, :lastmod => Party.unscoped.last.updated_at
  add affiches_path('parties', 'weekly'),       :changefreq => 'daily', :priority => 0.7, :lastmod => Party.unscoped.last.updated_at
  add affiches_path('parties', 'weekend'),      :changefreq => 'daily', :priority => 0.7, :lastmod => Party.unscoped.last.updated_at
  add affiches_path('parties', 'today'),        :changefreq => 'daily', :priority => 0.7, :lastmod => Party.unscoped.last.updated_at

  # Спектакли
  add affiches_path('spectacles', 'all'),       :changefreq => 'daily', :priority => 0.7, :lastmod => Spectacle.unscoped.last.updated_at
  add affiches_path('spectacles', 'weekly'),    :changefreq => 'daily', :priority => 0.7, :lastmod => Spectacle.unscoped.last.updated_at
  add affiches_path('spectacles', 'weekend'),   :changefreq => 'daily', :priority => 0.7, :lastmod => Spectacle.unscoped.last.updated_at
  add affiches_path('spectacles', 'today'),     :changefreq => 'daily', :priority => 0.7, :lastmod => Spectacle.unscoped.last.updated_at

  # Выставки
  add affiches_path('exhibitions', 'all'),      :changefreq => 'daily', :priority => 0.7, :lastmod => Exhibition.unscoped.last.updated_at
  add affiches_path('exhibitions', 'weekly'),   :changefreq => 'daily', :priority => 0.7, :lastmod => Exhibition.unscoped.last.updated_at
  add affiches_path('exhibitions', 'weekend'),  :changefreq => 'daily', :priority => 0.7, :lastmod => Exhibition.unscoped.last.updated_at
  add affiches_path('exhibitions', 'today'),    :changefreq => 'daily', :priority => 0.7, :lastmod => Exhibition.unscoped.last.updated_at

  # Спортивные мероприятия
  add affiches_path('sportsevents', 'all'),     :changefreq => 'daily', :priority => 0.7, :lastmod => SportsEvent.unscoped.last.updated_at
  add affiches_path('sportsevents', 'weekly'),  :changefreq => 'daily', :priority => 0.7, :lastmod => SportsEvent.unscoped.last.updated_at
  add affiches_path('sportsevents', 'weekend'), :changefreq => 'daily', :priority => 0.7, :lastmod => SportsEvent.unscoped.last.updated_at
  add affiches_path('sportsevents', 'today'),   :changefreq => 'daily', :priority => 0.7, :lastmod => SportsEvent.unscoped.last.updated_at

  # Другое
  add affiches_path('others', 'all'),           :changefreq => 'daily', :priority => 0.7, :lastmod => Other.unscoped.last.updated_at
  add affiches_path('others', 'weekly'),        :changefreq => 'daily', :priority => 0.7, :lastmod => Other.unscoped.last.updated_at
  add affiches_path('others', 'weekend'),       :changefreq => 'daily', :priority => 0.7, :lastmod => Other.unscoped.last.updated_at
  add affiches_path('others', 'today'),         :changefreq => 'daily', :priority => 0.7, :lastmod => Other.unscoped.last.updated_at

  # Фотогалереи
  add photogalleries_path('all'),               :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
  add photogalleries_path('month'),             :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
  add photogalleries_path('week'),              :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at

  # Заведения города Томска
  add organizations_path('organizations'),      :changefreq => 'daily', :priority => 0.7, :lastmod => Organization.unscoped.last.updated_at

  # Заведения общественного питания в Томске
  add organizations_path('meals'),              :changefreq => 'daily', :priority => 0.7, :lastmod => Meal.unscoped.last.updated_at

  # Развлекательные заведения в Томске
  add organizations_path('entertainments'),     :changefreq => 'daily', :priority => 0.7, :lastmod => Entertainment.unscoped.last.updated_at

  # Культурные заведения в Томске
  add organizations_path('cultures'),           :changefreq => 'daily', :priority => 0.7, :lastmod => Culture.unscoped.last.updated_at

  max_popularity = Affiche.all.map(&:popularity).max

  Affiche.find_each do |affiche|
    add send("#{affiche.class.name.downcase}_path", affiche),
      :changefreq => 'weekly',
      :priority => 0.9*affiche.popularity/max_popularity,
      :lastmod => affiche.updated_at,
      :images => [{ :loc => affiche.poster_url, :title => affiche.title }]
  end

  max_rating = Organization.all.map(&:rating).max

  Organization.find_each do |organization|
    add organization_path(organization),
      :changefreq => 'weekly',
      :priority => 0.9*organization.rating/max_rating,
      :lastmod => organization.updated_at,
      :images => [{ :loc => organization.logotype_url, :title => organization.title }]
  end
end
