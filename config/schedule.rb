require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
else
  set :job_template, "/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
end

every :day, :at => '6am' do
  rake 'cron'
end

every 2.hours do
  rake 'statistics:all'
end

every :day, :at => '5am' do
  rake "-s sitemap:refresh"
end
