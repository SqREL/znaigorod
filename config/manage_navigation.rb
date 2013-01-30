# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :organisations, 'Заведения города', manage_organizations_path,
      :highlights_on => ->(){ controller_name == 'organizations' || resource_class.try(:superclass) == Organization },
      :unless => -> { (current_user.roles & ["admin", "organization_editor"]).empty? }

    primary.item :main_page, 'ЗнайГород', root_url

    primary.item :affiches, 'Мероприятия города', manage_affiches_path,
      :highlights_on => ->(){ controller_name == 'affiches' || resource_class.try(:superclass) == Affiche },
      :unless => -> { (current_user.roles & ["admin", "affiche_editor"]).empty? }

    primary.item :posts, 'Посты города', manage_posts_path,
      :highlights_on => ->(){ controller_name == 'posts' || resource_class.try(:superclass) == Post },
      :unless => -> { (current_user.roles & ["admin", "post_editor"]).empty? }

    primary.item :contests, 'Конкурсы', manage_contests_path, :highlights_on => ->(){ controller_name == 'contests' || resource_class.try(:superclass) == Contest }

    primary.dom_class = 'navigation'
  end
end
