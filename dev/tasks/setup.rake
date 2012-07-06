gem 'railties'
require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

namespace :nimbleshop do
  namespace :setup do

    task :local do
      template_path = File.expand_path('../../templates/installer.rb', __FILE__)
      Rails::Generators::AppGenerator.start ['myshop', '-m', template_path, '--skip-index-html']

      puts ""
      puts "="*60
      puts "myshop is ready"
      puts "cd myshop"
      puts "rails server"
    end

    task :test do
      template_path = File.expand_path('../../templates/installer.rb', __FILE__)
      Rails::Generators::AppGenerator.start ['myshop_test', '-m', template_path, '--skip-index-html']
    end

  end
end
