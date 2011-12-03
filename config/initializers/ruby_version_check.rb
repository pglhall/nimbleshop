version = RUBY_VERSION

unless version == '1.9.2'
  puts '*'*80
  puts "You are using ruby version #{version} . nimbelSHOP currently supports only ruby version 1.9.2 ."
  puts '*'*80
  raise  ''
end
