# encoding: UTF-8
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run tests'
task :default => ['test']

task :test => ['nimbleshop_simply:ensure_test_app_exists', 'nimbleshop_simply:test']

namespace :nimbleshop_simply do

  task :ensure_test_app_exists do
    p = File.expand_path('../../../nimbleshop_core/test/myshop', __FILE__)
    abort 'Test app is missing. First execute "rake nimbleshop:setup:test_app"' unless File.directory?(p)
  end

  desc 'Run nimbleshop_simply tests.'
  Rake::TestTask.new(:test) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end

end
