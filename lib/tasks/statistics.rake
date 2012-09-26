namespace :statistics do
  desc 'Update Yandex.metrika page views count'
  task :yandex => :environment do
    Statistics::Yandex.new.update_affiches
  end
end
