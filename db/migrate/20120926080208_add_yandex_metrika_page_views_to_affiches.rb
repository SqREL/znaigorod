class AddYandexMetrikaPageViewsToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :yandex_metrika_page_views, :integer
  end
end
