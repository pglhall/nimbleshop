source 'http://rubygems.org'

# standard rails stuff
gem 'rails', '3.1.1'
gem 'jquery-rails'
gem 'will_paginate'
gem 'pg'

# to handle credit card payments
gem 'activemerchant'
gem 'binary_merchant', git: 'git://github.com/bigbinary/binary_merchant.git'
#gem 'binary_merchant', path: '/Users/nsingh/dev/personal/binary_merchant'

# themes should be in liquid to avoid any security issue
gem 'liquid'

# for uploading images
gem 'carrierwave'

gem 'nested_form', git: 'git://github.com/ryanb/nested_form.git'

# for creating thumbnails for images
gem 'mini_magick'

# to load sample data
gem 'yaml_db'

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'database_cleaner'
  gem 'guard'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard-minitest'
  gem 'minitest-rails'
  gem 'factory_girl_rails'
  gem "minitest-capybara", "~> 0.0.1", git: "git://github.com/clnclarinet/minitest-capybara.git"
  gem 'database_cleaner'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

# visit /admin_data to manage data using browser
gem 'admin_data', '= 1.1.16'
#gem 'admin_data', path: '/Users/nsingh/dev/personal/admin_data'
#gem 'admin_data', git: 'git://github.com/bigbinary/admin_data.git', branch: 'test'


# to support various themes
gem 'themes_for_rails', git: 'git://github.com/neerajdotname/themes_for_rails.git'
#gem 'themes_for_rails', path: '/Users/nsingh/dev/personal/themes_for_rails'

gem 'email_validator', :git => "git://github.com/bigbinary/email_validator.git"
