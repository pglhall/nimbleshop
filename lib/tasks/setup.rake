desc "sets up environment"
task :setup => :environment do

 #raise "this task should not be run in production" if Rails.env.production?

  Rake::Task["db:reset"].invoke unless Settings.using_heroku

  Rake::Task["db:seed"].invoke

  PaymentMethod.load_seed_data!
  PaymentMethod.update_all(enabled: true)

  Sampledata.new.populate
end
