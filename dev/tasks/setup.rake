#
# This file is responsible for creating local rails application for
# development and testing purpose.
#
# Execute: rake nimbleshop:setup:local to have a rails application at
# dev/myshop . This is your development rails application to test out
# nimbleShop .
#
# Execute rake nimbleshop:setup:test to have a rails application at
# nimbleshop_core/test/myshop. The tests run against this rails
# application .
#
gem 'railties'
require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

namespace :nimbleshop do
  namespace :setup do

    task :local do
      template_path = File.expand_path('../../templates/installer.rb', __FILE__)
      dev_path = File.expand_path('../../../dev', __FILE__)
      Rails::Generators::AppGenerator.start ['myshop', '-m', template_path], destination_root: dev_path

      puts ""
      puts "myshop is ready"
      puts "cd dev/myshop"
      puts "rails server"
    end

    task :test do
      FileUtils.rm_rf File.expand_path('../../../nimbleshop_core/test/myshop', __FILE__)
      template_path = File.expand_path('../../templates/installer.rb', __FILE__)
      test_path = File.expand_path('../../../nimbleshop_core/test', __FILE__)
      Rails::Generators::AppGenerator.start ['myshop', '-m', template_path], destination_root: test_path
    end

  end
end
