source 'http://rubygems.org'

# standard rails stuff
gem 'rails', '3.2.1'
gem 'will_paginate'
gem 'pg'

# to support various themes
#
# gem 'themes_for_rails', git: 'git://github.com/lucasefe/themes_for_rails.git'
# gem 'themes_for_rails',  path:'/Users/nsingh/dev/personal/themes_for_rails'
gem 'themes_for_rails',  git: 'git://github.com/neerajdotname/themes_for_rails.git'

# splitable needs this to send POST request
gem 'faraday'

# heroku cedar stack needs it
gem 'thin'

# to handle credit card payments
gem 'activemerchant'
gem 'binary_merchant', git: 'git://github.com/bigbinary/binary_merchant.git'

# for uploading images
gem 'carrierwave'

# for having nested items. order has billing_address and shipping_address nested
gem 'nested_form', git: 'git://github.com/ryanb/nested_form.git'

# for creating thumbnails for images
gem 'mini_magick'

# to manage states of payment_status and shipping_status
gem 'state_machine'

# visit /admin_data to manage data using browser
gem 'admin_data', '= 1.1.16'

# mustache.js
#
# Mustache is used to generate new product-group-condition
gem 'mustache'

# for validating email
gem 'email_validator', git: "git://github.com/bigbinary/email_validator.git"

# to make settings more flexible. Without hashr the code would be like this
#  Settings.s3['bucket_name']
# with hashr it becomes
#  Settings.s3.bucket_name
#
#  I can't use open-struct because that does not list all the keys
gem 'hashr'

# This gem maintains all the country codes and subregions for some of the countries
gem 'carmen', git: 'git://github.com/jim/carmen.git'

# for uploading pictures to s3 using carrierwave
gem 'fog'

# for error notification
gem "airbrake"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'

  # when command
  #     rails generate model User
  # is exected then following gem ensures that tests are generated using minitest
  gem 'minitest-rails', git: 'git://github.com/neerajdotname/minitest-rails.git'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem "capybara_minitest_spec"

  gem 'minitest', '~> 2.10.1'
  gem 'minitest-matchers'
  gem 'valid_attribute', git: "git://github.com/wojtekmach/valid_attribute.git", branch: "minitest-matchers-11"

  gem 'guard'
  gem 'guard-minitest'

  gem 'sqlite3' # capybara-webkit hangs if run with postgresql

  # Colorize MiniTest output and show failing tests instantly
  gem 'minitest-colorize', git: 'https://github.com/nohupbrasil/minitest-colorize'

  gem 'database_cleaner'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'factory_girl_rails'
  gem "launchy"
  gem 'shoulda-matchers'
  gem 'rr'
end
