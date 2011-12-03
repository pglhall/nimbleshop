namespace :db do

  desc "rebuilds the database and adds seed data"
  task :bootstrap => :environment do
    raise "this task should not be run in production" if Rails.env.production?
    #heroku pg:reset SHARED_DATABASE --remote staging --confirm nimbleshop-staging

    puts "dropping the database ..."
    Rake::Task["db:drop"].invoke

    puts "creating the database .."
    Rake::Task["db:create"].invoke

    puts "running db:migrate ..."
    Rake::Task["db:migrate"].invoke

    puts "running db:seed ..."
    Rake::Task["db:data:load"].invoke
    Rake::Task["db:seed"].invoke

    #puts "running db:test:prepare ..."
    #Rake::Task["db:test:prepare"].invoke
  end

end
