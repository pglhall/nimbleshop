desc "sets up environment"
task :setup => :environment do

 #raise "this task should not be run in production" if Rails.env.production?

  Rake::Task["db:reset"].invoke unless Settings.using_heroku

  Rake::Task["db:seed"].invoke

  PaymentMethod.load_default!
  PaymentMethod.update_all(enabled: true)

  Sampledata.new.populate
end

desc "sets up enviroment from scratch"
task :setup_from_scratch => :environment do
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke
  Rake::Task["setup"].invoke
end
