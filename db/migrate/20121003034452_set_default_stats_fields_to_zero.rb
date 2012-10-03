class SetDefaultStatsFieldsToZero < ActiveRecord::Migration
  def up
    Affiche.where(:yandex_metrika_page_views => nil).update_all(:yandex_metrika_page_views => 0)
    Affiche.where(:vkontakte_likes => nil).update_all(:vkontakte_likes => 0)
  end

  def down
  end
end
