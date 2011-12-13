desc "setsup local development environment"
task :setup_development => :environment do
  Rake::Task["db:bootstrap"].invoke
  Rake::Task["db:reset_sample_data"].invoke
end

namespace :db do

  desc "resets the sample data sample data"
  task :reset_sample_data => :environment do
    #raise "this task should not be run in production" if Rails.env.production?
    #heroku pg:reset SHARED_DATABASE --remote staging --confirm nimbleshop-staging

    puts "running db:sample_data ..."
    Shop.delete_all
    Link.delete_all
    LinkGroup.delete_all
    ProductGroup.delete_all
    Page.delete_all
    CustomField.delete_all
    Order.delete_all
    CustomFieldAnswer.delete_all
    ShippingMethod.delete_all
    ShippingZone.delete_all

    Shop.create!(name: 'nimbleshop',
                 theme: 'spotless',
                 phone_number: '800-456-7890',
                 contact_email: 'neeraj@nimbleshop.com',
                 twitter_handle: '@nimbleshop',
                 facebook_url: 'www.facebook.com')
    @shop = Shop.first
    @shop.update_attributes(gateway: 'website_payments_standard')
    @shop.update_attributes(gateway: 'AuthorizeNet')

    link_group = LinkGroup.create!(name: 'Main-nav')
    link_home = Link.create!(name: 'Home', url: '/')
    Navigation.create!(link_group: link_group, navigeable: link_home)

    cf = CustomField.create!(name: 'category', field_type: 'text')
    Product.find(5).custom_field_answers.create(custom_field: cf, value: 'bracelet')
    Product.find(4).custom_field_answers.create(custom_field: cf, value: 'bracelet')
    Product.find(8).custom_field_answers.create(custom_field: cf, value: 'bracelet')
    Product.find(10).custom_field_answers.create(custom_field: cf, value: 'earring')
    Product.find(7).custom_field_answers.create(custom_field: cf, value: 'earring')
    Product.find(6).custom_field_answers.create(custom_field: cf, value: 'necklace')
    Product.find(9).custom_field_answers.create(custom_field: cf, value: 'necklace')

    pg_bracelets = ProductGroup.create!(name: 'bracelets', :condition => {"q#{cf.id}" => { op: 'eq', v: 'bracelet'}})
    pg_earrings = ProductGroup.create!(name:  'earrings',  :condition => {"q#{cf.id}" => { op: 'eq', v: 'earring'}})
    pg_necklaces = ProductGroup.create!(name: 'necklaces', :condition => {"q#{cf.id}" => { op: 'eq', v: 'necklace'}})

    link_group = LinkGroup.create!(name: 'Shop by category')
    Navigation.create!(link_group: link_group, navigeable: pg_bracelets)
    Navigation.create!(link_group: link_group, navigeable: pg_earrings)
    Navigation.create!(link_group: link_group, navigeable: pg_necklaces)

    cf = CustomField.create!(name: 'price', field_type: 'number')
    Product.find(4).update_attributes(price: 10)
    Product.find(4).custom_field_answers.create(custom_field: cf, value: 10)

    Product.find(5).update_attributes(price: 47)
    Product.find(5).custom_field_answers.create(custom_field: cf, value: 47)

    Product.find(6).update_attributes(price: 78)
    Product.find(6).custom_field_answers.create(custom_field: cf, value: 78)

    Product.find(7).update_attributes(price: 81)
    Product.find(7).custom_field_answers.create(custom_field: cf, value: 81)

    Product.find(8).update_attributes(price: 107)
    Product.find(8).custom_field_answers.create(custom_field: cf, value: 107)

    Product.find(9).update_attributes(price: 137)
    Product.find(9).custom_field_answers.create(custom_field: cf, value: 137)

    Product.find(10).update_attributes(price: 141)
    Product.find(10).custom_field_answers.create(custom_field: cf, value: 141)

    pg_lt_50 = ProductGroup.create!(name: '< $50', :condition => {"q#{cf.id}" => { op: 'lt', v: 50}})
    pg_between_50_100 = ProductGroup.create!(name: '$50 - $100',
                                             :condition => {"q#{cf.id}" => [{ op: 'gteq', v: 50}, { op: 'lteq', v: 100}]})
    pg_gt_100 = ProductGroup.create!(name: '> $100', :condition => {"q#{cf.id}" => { op: 'gt', v: 100}})

    link_group = LinkGroup.create!(name: 'Shop by price')
    Navigation.create!(link_group: link_group, navigeable: pg_lt_50)
    Navigation.create!(link_group: link_group, navigeable: pg_between_50_100)
    Navigation.create!(link_group: link_group, navigeable: pg_gt_100)

    PaymentMethod.update_all(enabled: true)
    sz = ShippingZone.create!(name: 'USA')
    ShippingCountry.create!(shipping_zone_id: sz.id, country_code: 'USA')
    ShippingMethod.create!(name: 'ground shipping', shipping_price: 10, shipping_zone_id: sz.id,
                           lower_price_limit: 10, upper_price_limit: 20)
    ShippingMethod.create!(name: 'ground shipping', shipping_price: 20, shipping_zone_id: sz.id,
                           lower_price_limit: 20, upper_price_limit: 300)

    ShippingMethod.create!(name: 'express shipping', shipping_price: 15, shipping_zone_id: sz.id,
                           lower_price_limit: 10, upper_price_limit: 20)
    ShippingMethod.create!(name: 'express shipping', shipping_price: 25, shipping_zone_id: sz.id,
                           lower_price_limit: 20, upper_price_limit: 300)

  end

end
