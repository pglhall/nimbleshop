desc "setsup local development environment"
task :setup_development => :environment do

  if Settings.using_heroku
    ActiveRecord::Base.connection.tables.collect{|t| t.classify.constantize rescue nil }.compact.each do |klass|
      klass.delete_all
    end
  else
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  Rake::Task["db:data:load"].invoke
  Rake::Task["db:seed"].invoke

  ActiveRecord::Base.connection.tables.collect{|t| t.classify.constantize rescue nil }.compact.each do |klass|
    case klass.name
    when *['Product', 'Picture', 'Creditcard', 'PaymentMethod']
    when *%w(Product Picture Creditcard PaymentMethod)
    else
      klass.delete_all
    end
  end

  payment_method = PaymentMethod::Splitable.find_by_permalink!('splitable')
  payment_method.write_preference(:api_secret, 'AGT568GKLRW39S')
  payment_method.write_preference(:expires_in, '24')
  payment_method.write_preference(:submission_url, 'http://lvh.me:3000/split_payments/split?')
  payment_method.write_preference(:logo_url, 'http://edibleapple.com/wp-content/uploads/2009/04/silver-apple-logo.png')
  payment_method.write_preference(:api_key, '42398cc9ac420bf4')
  payment_method.save!

  payment_method = PaymentMethod.find_by_permalink!('authorize-net')
  payment_method.write_preference(:login_id, '56yBAar72')
  payment_method.write_preference(:transaction_key, '9r3pbH5bnKH29f7d')
  payment_method.save!

  payment_method = PaymentMethod.find_by_permalink!('paypal-website-payments-standard')
  payment_method.write_preference(:merchant_email_address, 'seller_1323037155_biz@bigbinary.com')
  payment_method.write_preference(:return_url, 'http://localhost:3000/paypal_return')
  payment_method.write_preference(:notify_url, 'http://localhost:3000/payment_notifications/paypal')
  payment_method.write_preference(:request_submission_url, 'https://www.sandbox.paypal.com/cgi-bin/webscr?')
  payment_method.save!

  shop = Shop.create!( name: 'nimbleshop',
                       theme: 'nootstrap',
                       phone_number: '800-456-7890',
                       contact_email: 'neeraj@nimbleshop.com',
                       twitter_handle: '@nimbleshop',
                       facebook_url: 'www.facebook.com')

  shop.update_attributes!( gateway:  'AuthorizeNet',
                           facebook_url: 'http://www.facebook.com/pages/NimbleSHOP/119319381517845',
                           twitter_handle:  'nimbleshop')

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
  link_group.navigations.create(navigeable: pg_bracelets)
  link_group.navigations.create(navigeable: pg_earrings)
  link_group.navigations.create(navigeable: pg_necklaces)

  cf = CustomField.create!(name: 'original price', field_type: 'number')
  Product.find(4).update_attributes(price: 10)
  Product.find(5).update_attributes(price: 47)
  Product.find(6).update_attributes(price: 78)
  Product.find(7).update_attributes(price: 81)
  Product.find(8).update_attributes(price: 107)
  Product.find(9).update_attributes(price: 137)
  Product.find(10).update_attributes(price: 141)

  pg_lt_50 = ProductGroup.create!(name: '< $50', :condition => { "price" => { op: 'lt', v: 50 } })
  pg_between_50_100 = ProductGroup.create!(name: '$50 - $100',
                                           :condition => [{"price" => { op: 'gteq', v: 50}}, {"price" => { op: 'lteq', v: 100}}])
  pg_gt_100 = ProductGroup.create!(name: '> $100', :condition => {"price" => { op: 'gt', v: 100}})

  link_group = LinkGroup.create!(name: 'Shop by price')
  Navigation.create!(link_group: link_group, navigeable: pg_lt_50)
  Navigation.create!(link_group: link_group, navigeable: pg_between_50_100)
  Navigation.create!(link_group: link_group, navigeable: pg_gt_100)

  PaymentMethod.update_all(enabled: true)
  sz = ShippingZone.create!(name: 'USA')
  ShippingCountry.create!(shipping_zone_id: sz.id, country_code: 'USA')
  ShippingMethod.create!(name: 'Ground shipping', shipping_price: 10, shipping_zone_id: sz.id,
                         lower_price_limit: 10, upper_price_limit: 20)
  ShippingMethod.create!(name: 'Ground shipping', shipping_price: 20, shipping_zone_id: sz.id,
                         lower_price_limit: 20)

  ShippingMethod.create!(name: 'Express shipping', shipping_price: 15, shipping_zone_id: sz.id,
                         lower_price_limit: 10, upper_price_limit: 20)
  ShippingMethod.create!(name: 'Express shipping', shipping_price: 25, shipping_zone_id: sz.id,
                         lower_price_limit: 20)

  order = Order.create!
  CreditcardTransaction.create!(transaction_gid: '2167825945',
                                params: '--- response_code: 1 response_reason_code: "1" response_reason_text: This transaction has been approved. avs_result_code: Y transaction_id: "2167825945" card_code: P',
                                amount: 141,
                                creditcard_id: Creditcard.last,
                                order_id: order.id,
                                status: 'authorized')

  order.add(Product.find_by_permalink('claddagh-earrings'))
  order.shipping_address = ShippingAddress.new(first_name: 'Johnnie',
                                               last_name: 'Walker',
                                               address1: '100 Main Street',
                                               state: 'Florida',
                                               city: 'Miami',
                                               zipcode: '33332',
                                               country: 'USA',
                                               use_for_billing: true)

  order.shipping_method = order.available_shipping_methods.first
  order.email = 'hello.nimbleshop@gmail.com'
  order.save!

end
