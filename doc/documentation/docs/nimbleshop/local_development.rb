---
layout: nimbleshop
title: Setting up local development environment
---

# Setting up local development environment

    git clone ....
    cp config/database.yml.example config/database.yml
    bundle install
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:bootstrap

Start rails server

    rails server

Visit the application at http://localhost:3000 .

Visit the admin page at http://localhost:3000/admin . Default admin login email is _admin@example.com_.
