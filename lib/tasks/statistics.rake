namespace :statistics do
  desc 'Update Yandex.metrika page views count'
  task :yandex => :environment do
    Statistics::Yandex.new.update_affiches
  end

  desc 'Update VK likes count'
  task :vkontakte => :environment do
    Statistics::Vkontakte.new.update_affiches
  end

  desc 'Update Yandex.metrika and VK statistics'
  task :all => [:yandex, :vkontakte] do
  end
end
