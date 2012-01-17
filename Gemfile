source 'http://rubygems.org'

# standard rails stuff
gem 'rails', '3.1.1'
gem 'jquery-rails'
gem 'will_paginate'
gem 'pg'

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

# to load sample data. It should be gone soon
gem 'yaml_db'

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'database_cleaner'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-minitest'
  gem 'minitest-rails'
  gem 'factory_girl_rails'
  gem 'capybara', git: 'git://github.com/jnicklas/capybara.git'
  gem "capybara_minitest_spec"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

# visit /admin_data to manage data using browser
gem 'admin_data', '= 1.1.16'
gem 'mustache'

# to support various themes
#gem 'themes_for_rails', git: 'git://github.com/lucasefe/themes_for_rails.git'
#gem 'themes_for_rails',  path:'/Users/nsingh/dev/personal/themes_for_rails'
gem 'themes_for_rails',  git: 'git://github.com/neerajdotname/themes_for_rails.git'

# for validating email
gem 'email_validator', git: "git://github.com/bigbinary/email_validator.git"

