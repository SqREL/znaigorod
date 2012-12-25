class AddYandexMetrikaPageViewsAndVkontakteLikesToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :yandex_metrika_page_views, :integer
    add_column :organizations, :vkontakte_likes, :integer
  end
end
