desc "sets up environment"
task :setup => :environment do

 #raise "this task should not be run in production" if Rails.env.production?

  Rake::Task["db:reset"].invoke unless Settings.using_heroku

  Rake::Task["db:seed"].invoke

  Sampledata.new.populate

  Rake::Task["nimbleshop_splitable:load_record"].invoke
  Rake::Task["nimbleshop_paypalwp:load_record"].invoke
  Rake::Task["nimbleshop_authorizedotnet:load_record"].invoke

end
