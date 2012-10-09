class AddYandexFotkiUrlToAffiche < ActiveRecord::Migration
  def change
    add_column :affiches, :yandex_fotki_url, :string
  end
end
