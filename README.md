# nimbleSHOP

nimbleSHOP is a highly opinionated open source eCommerce platform.

* It uses postgresql. It might or might not work with MySQL.
* It requires ruby 1.9.2. It will not work with ruby 1.8.7 .
* Out of the box it can be deployed on heroku. See documentation for more information.
* Out of the box it supports paypal and Authorize.Net. See documentation for more information.

# Documentation

Documentation is available at "http://nimbleshop-guides.heroku.com":http://nimbleshop-guides.heroku.com .

# setup

    cp config/database.yml.example config/database.yml
    bundle install
    bundle exec rake setup_development

# Tests

Execute the following line to run all the tests.

    guard

Hit shift + enter to execute all the tests.

If you want to run tests for one single file then that can be done like this.

    bundle exec ruby -Ispec spec/models/product_spec.rb

# Admin

To perform admin functionalities "visit":http://localhost:3000/admin
