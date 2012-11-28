def deploy_to
  Rails.root.join('..')
end

desc 'Refresh sitemap'
task :refresh_sitemaps => :environment do
  #if Rails.env.production?
    Rake::Task['sitemap:refresh'].execute

    #Kernel.system "gunzip -c #{deploy_to}/shared/sitemaps/sitemap1.xml.gz > #{deploy_to}/shared/sitemaps/sitemap1.xml"
    #Kernel.system "ln -s #{deploy_to}/shared/sitemaps/sitemap1.xml.gz #{release_path}/public/sitemap.xml.gz"
    #Kernel.system "ln -s #{deploy_to}/shared/sitemaps/sitemap1.xml #{release_path}/public/sitemap.xml"
  #else
    #puts 'Run this task on production server'
  #end
end
