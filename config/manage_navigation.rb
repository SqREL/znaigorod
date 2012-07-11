# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :organisations, 'Список заведений', manage_organizations_path, :highlights_on => ->(){ controller_name == 'organizations' && action_name == 'index' }
    primary.item :add_organization, 'Добавить заведение', new_manage_organization_path, :highlights_on => ->(){ controller_name == 'organizations' && %w(create new).include?(action_name) }
    primary.item :affiches, 'Список мероприятий', manage_affiches_path, :highlights_on => ->(){ controller_name == 'affiches' && action_name == 'index' }
    primary.item :add_affiches, 'Добавить мероприятие', new_manage_affiche_path, :highlights_on => ->(){ controller_name == 'affiches' && %w(create new).include?(action_name) }
    primary.dom_class = 'nav'
  end
end
