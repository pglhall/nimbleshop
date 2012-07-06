path = Pathname.new(File.expand_path('../../../', __FILE__))

append_file 'Gemfile', <<-GEMFILE

gem 'nimbleshop_core',            path: "#{path.join('nimbleshop_core')}"
gem 'nimbleshop_simply',          path: "#{path.join('nimbleshop_simply')}"

gem 'nimbleshop_authorizedotnet', path: "#{path.join('nimbleshop_authorizedotnet')}"
gem 'nimbleshop_paypalwp',        path: "#{path.join('nimbleshop_paypalwp')}"
gem 'nimbleshop_splitable',       path: "#{path.join('nimbleshop_splitable')}"
gem 'nimbleshop_cod',             path: "#{path.join('nimbleshop_cod')}"

GEMFILE

run 'bundle install'

generate 'nimbleshop:install'

run 'bundle exec rake db:create'
run 'bundle exec rake nimbleshop:setup:db'
run 'bundle exec rake db:test:prepare'
