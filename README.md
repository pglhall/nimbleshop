# nimbleSHOP

nimbleSHOP is a highly opinionated open source eCommerce platform.

* It uses postgresql. It might or might not work with MySQL.
* It requires ruby 1.9.2. It will not work with ruby 1.8.7 .
* Out of the box it can be deployed on heroku. See documentation for more information.
* Out of the box it supports paypal and Authorize.Net. See documentation for more information.

# postgresql database

nimbleShop uses postgresql. All code is written and tested in postgresql. To the extent I know there is no sql writtent specifically for postgresql so the application should work for mysql and other databases.

# setup

    cp config/database.yml.example config/database.yml
    bundle install
    bundle exec rake db:create
    bundle exec rake db:sample_data

# Tests

Execute the following line to run all the tests.

    guard

Hit shift + enter to execute all the tests.

If you want to run tests for one single file then that can be done like this.

    bundle exec ruby -Ispec spec/models/product_spec.rb


# Admin

visit http://localhost:3000/admin

# change theme

To change theme go to 'admin' page by visiting http://localhost:3000/admin and then click on 'Shop configuration'.
There type in the name of your new 'theme'.
