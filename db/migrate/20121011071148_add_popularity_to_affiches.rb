class AddPopularityToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :popularity, :float
    Affiche.update_all('popularity = 0.3 * vkontakte_likes + yandex_metrika_page_views')
  end
end
