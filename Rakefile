Dir[File.expand_path('../dev/tasks/**/*', __FILE__)].each do |task|
  load task
end

engines = %w(nimbleshop_core nimbleshop_authorizedotnet nimbleshop_splitable nimbleshop_paypalwp)

desc 'Run all tests by default'
task :default => %w(test)

%w(test).each do |task_name|
  desc "Run #{task_name} task for all engines"
  task task_name do
    errors = []
    engines.each do |engine|
      system(%(cd #{engine} && #{$0} #{task_name})) || errors << engine
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

