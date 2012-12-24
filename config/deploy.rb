require "bundler/capistrano"
require "rvm/capistrano"

load "config/deploy/settings"
load "config/deploy/assets"
load "config/deploy/database"
#load "config/deploy/solr"
load "config/deploy/tag"

namespace :deploy do
  desc "Copy config files"
  task :config_app, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Precompile assets"
  task :compile_assets, :roles => :app do
    run "cd #{deploy_to}/current && RAILS_ENV=production bin/rake assets:precompile"
  end

  desc "HASK copy right unicorn.rb file"
  task :copy_unicorn_config do
    run "mv #{deploy_to}/current/config/unicorn.rb #{deploy_to}/current/config/unicorn.rb.example"
    run "ln -s #{deploy_to}/shared/config/unicorn.rb #{deploy_to}/current/config/unicorn.rb"
  end

  desc "Reload Unicorn"
  task :reload_servers do
    sudo "/etc/init.d/nginx reload"
    sudo "/etc/init.d/#{unicorn_instance_name} restart"
  end

  desc "Airbrake notify"
  task :airbrake do
    run "cd #{deploy_to}/current && RAILS_ENV=production TO=production bin/rake airbrake:deploy"
  end

  desc "Sunspot solr reindex"
  task :sunspot_reindex do
    run "cd #{deploy_to}/current && RAILS_ENV=production bin/rake sunspot:reindex"
  end

  desc "Update crontab tasks"
  task :crontab do
    run "cd #{deploy_to}/current && exec bundle exec whenever --update-crontab --load-file #{deploy_to}/current/config/schedule.rb"
  end

  desc 'Refresh sitemap'
  task :refresh_sitemaps do
    run "cd #{deploy_to}/current && RAILS_ENV=production bin/rake sitemap:refresh"
    run "gunzip -c #{deploy_to}/shared/sitemaps/sitemap1.xml.gz > #{deploy_to}/shared/sitemaps/sitemap1.xml"
    run "ln -s #{deploy_to}/shared/sitemaps/sitemap1.xml.gz #{release_path}/public/sitemap.xml.gz"
    run "ln -s #{deploy_to}/shared/sitemaps/sitemap1.xml #{release_path}/public/sitemap.xml"
  end
end

# deploy
after "deploy:finalize_update", "deploy:config_app"
after "deploy", "deploy:migrate"
after "deploy", "deploy:copy_unicorn_config"
after "deploy", "deploy:reload_servers"
after "deploy:restart", "deploy:cleanup"
after "deploy", "deploy:crontab"
after "deploy", "deploy:refresh_sitemaps"
after "deploy", "deploy:airbrake"

# deploy:rollback
after "deploy:rollback", "deploy:reload_servers"
