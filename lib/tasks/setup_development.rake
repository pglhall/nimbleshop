namespace :ns do
  task :dump_data do
    FileUtils.rm_rf(Rails.root.join('db', 'data'))
    ENV['dir'] = 'data'
    Rake::Task["db:data:dump_dir"].invoke
    dir = Rails.root.join('db', 'data')

    Dir.foreach(dir) do |i|
      if i =~ /yml/
        if ['pictures.yml', 'creditcards.yml'].include? i
        else
          FileUtils.rm( Rails.root.join('db', 'data', i ))
        end
      end
    end
  end

  task :load_data do
    ENV['dir'] = 'data'
    Rake::Task["db:data:load_dir"].invoke
  end
end

desc "sets up local development environment"
task :setup_development => :environment do

  if Settings.using_heroku
    system "heroku pg:reset SHARED_DATABASE_URL --confirm chickscorner-staging"
    Rake::Task["db:migrate"].invoke
  else
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  ActiveRecord::Base.connection.tables.collect{|t| t.classify.constantize rescue nil }.compact.each do |klass|
    klass.delete_all
  end

  Rake::Task["db:seed"].invoke
  Rake::Task["ns:load_data"].invoke

  product4 = Product.create!( title: "Howlite and Crystal Flower Bracelet", price: 10, description: 'tbd')

  product5 = Product.create!( title: "Candy Colours Bracelet Set", price: 47, description: 'tbd')

  product6 = Product.create!( title: "Gemstone Cross Necklaces", price: 78, description: 'tbd')

  product7 = Product.create!( title: "Large Sterling Silver Hoop Earrings Aqua Freshwater Pearls Moonstone Hammered",
                              price: 81,
                              description: 'tbd')

  product8 = Product.create!( title: "Red, Black & Silver Glass Bracelet", price: 107, description: 'tbd')

  product9 = Product.create!( title: "Layered Coral Necklace", price: 137, description: 'tbd')

  product10 = Product.create!( title: "Claddagh Earrings", price: 141, description: 'tbd')

  product11 = Product.create!( title: "Om necklace", price: 101, description: 'tbd')

  product12 = Product.create!(title: "Men bracelet", price: 32, description: 'tbd')

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

  shop = Shop.create!( name: 'chickscorner',
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
  product5.custom_field_answers.create(custom_field: cf, value: 'bracelet')
  product4.custom_field_answers.create(custom_field: cf, value: 'bracelet')
  product8.custom_field_answers.create(custom_field: cf, value: 'bracelet')
  product10.custom_field_answers.create(custom_field: cf, value: 'earring')
  product7.custom_field_answers.create(custom_field: cf, value: 'earring')
  product6.custom_field_answers.create(custom_field: cf, value: 'necklace')
  product9.custom_field_answers.create(custom_field: cf, value: 'necklace')

  pg_bracelets = ProductGroup.create!(name: 'bracelets')
  pg_bracelets.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'bracelet')
  pg_earrings = ProductGroup.create!(name:  'earrings')
  pg_earrings.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'earring')
  pg_necklaces = ProductGroup.create!(name: 'necklaces')
  pg_necklaces.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'necklace')

  link_group = LinkGroup.create!(name: 'Shop by category')
  link_group.navigations.create(navigeable: pg_bracelets)
  link_group.navigations.create(navigeable: pg_earrings)
  link_group.navigations.create(navigeable: pg_necklaces)

  cf = CustomField.create!(name: 'original price', field_type: 'number')
  product4.update_attributes(price: 10)
  product5.update_attributes(price: 47)
  product6.update_attributes(price: 78)
  product7.update_attributes(price: 81)
  product8.update_attributes(price: 107)
  product9.update_attributes(price: 137)
  product10.update_attributes(price: 141)

  pg_lt_50 = ProductGroup.create!(name: '< $50')
  pg_lt_50.product_group_conditions.create(name: 'price', operator: 'lt', value: 50)
  pg_between_50_100 = ProductGroup.create!(name: '$50 - $100')
  pg_between_50_100.product_group_conditions.create(name: 'price', operator: 'gteq', value: 50)
  pg_between_50_100.product_group_conditions.create(name: 'price', operator: 'lteq', value: 100)
  pg_gt_100 = ProductGroup.create!(name: '> $100')
  pg_gt_100.product_group_conditions.create(name: 'price', operator: 'gt', value: 100)

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

  order.shipping_status = 'shipping_pending'
  order.save!

  CreditcardTransaction.create!(transaction_gid: '2167825945',
                                params: '--- response_code: 1 response_reason_code: "1" response_reason_text: This transaction has been approved. avs_result_code: Y transaction_id: "2167825945" card_code: P',
                                amount: 141,
                                creditcard_id: Creditcard.last,
                                order_id: order.id,
                                status: 'authorized')

  desc = "This lovely elastic bracelet is made of dyed turquoise Howlite flowers and champagne colored crystals. It is fun and goes with any outfit!  A bracelet is an article of jewelry which is worn around the wrist. Bracelets can be manufactured from metal, leather, cloth, plastic or other materials and sometimes contain jewels, rocks, wood, and/or shells. Bracelets are also used for medical and identification purposes, such as allergy bracelets and hospital patient-identification tags."
  product4.update_attributes(description: desc)

  desc = "acrylic stretch beaded bracelets with peace sign, butterfly and heart charms. A bracelet is an article of jewelry which is worn around the wrist. Bracelets can be manufactured from metal, leather, cloth, plastic or other materials and sometimes contain jewels, rocks, wood, and/or shells. Bracelets are also used for medical and identification purposes, such as allergy bracelets and hospital patient-identification tags."
  product5.update_attributes(description: desc)

  des = %q{
      "Gorgeous gemstone cross necklace, choice of green snowflake #1, turquoise, orange jasper, amethyst, green snowflake #2, rose quartz and tiger eye.

        Cross pendants are a very personal choice for the wearer. Whether you wear one as a display of your faith, to make a fashion statement, or just because you enjoy their beauty and elegance, we have a variety of gemstone cross pendants to suit virtually any taste or budget. Each pendant features beautifully set gemstones, positioned to enhance and embellish the pendant\xE2\x80\x99s attractiveness. From semi-precious to precious gemstones, bold colors to softly muted hues, the selection of embellished crosses here have something for everyone. Choose from settings in 14k white gold, 14k yellow gold, or sterling silver. Gemstones include jade, garnet, amethyst, pearls, sapphires, diamonds, rubies, emeralds, and more. We offer a variety of sizes, from small and understated, to bold and decorative. You are sure to find whatever you are looking for in this dazzling display of artistry and craftsmanship designed to meet the needs of any budget or preference."
    }
  product6.update_attributes(description: desc)

  desc = %q{
        These large hand forged Sterling Silver hoops are comfortable and lightweight. I have lightly hammered them for shine and strength.

        The hoops are adorned with aqua Chalcedony, creamy freshwater pearls, and moonstone. All of these gorgeous stones are wrapped in Sterling Silver wire.

        All Olivia Clare jewelry is lovingly made in my Hawaiian Studio on the Big Island.
  }
  product7.update_attributes(description: desc)

  desc = %q{
      "Deep red oval faceted beads with clear glass rondelles with red and black stripes. I added some silver plated \"Turkish knot\" spacers and some clear silver edged Czech glass table cut beads.

        This one is 7 3/4\" or 19cm long This item is handmade by myself and is totally original in design and is the only one that will ever be made, so if you decide to own this item, you will have a truly unique and beautiful item in your jewelry collection. Thank you for looking and have a nice day! - Lottie :) \xC2\xA9 Lottie's Trinkets 2005 - 2011 - All Rights Reserved Ref LT Red Stripe"
  }
  product8.update_attributes(description: desc)

  desc = %q{
      Om necklace for men .

        The syllable om is first described as all-encompassing mystical entity in the Upanishads. Today, in all Hindu art and all over India and Nepal, 'om' can be seen virtually everywhere, a common sign for Hinduism and its philosophy and theology. Hindus believe that as creation began, the divine, all-encompassing consciousness took the form of the first and original vibration manifesting as sound \"OM\".
        \r\n Before creation began it was \"Shuny\xC4\x81k\xC4\x81sha\", the emptiness or the void. Shuny\xC4\x81k\xC4\x81sha, meaning literally \"no sky\", is more than nothingness, because everything then existed in a latent state of potentiality. The vibration of \"OM\" symbolizes the manifestation of God in form (\"s\xC4\x81guna brahman\"). \"OM\" is the reflection of the absolute reality, it is said to be \"Adi Anadi\", without beginning or the end and embracing all that exists.
        \r\n The mantra \"OM\" is the name of God, the vibration of the Supreme. When taken letter by letter, A-U-M represents the divine energy (Shakti) united in its three elementary aspects: Bhrahma Shakti (creation), Vishnu Shakti (preservation) and Shiva Shakti (liberation, and/or destruction)."
  }
  product11.update_attributes(description: desc)


  desc = %w{ Dude you got a bracelet. }
  product12.update_attributes(description: desc)

  desc = %q{
        These earrings have Irish claddagh silver charms dangling from wire wrapped erinite green Swarovski crystals and silver beads, hanging from silver earwires.

        The length is 1 5/8" from the earwire loop. The claddagh symbol is two hands gently holding a crowned heart.
  }
  product10.update_attributes(description: desc)

  desc = %q{
      "Simple layered necklace made from \"farmed\" coral (sustainable). I spaced the beds with gold plated daisy spacers and then added some simple gold plated chain to give the desired length. \r\n\
        \r\n\
        This one 21\" or 53cm long This item is handmade by myself and is totally original in design and is the only one that will ever be made, so if you decide to own this item, you will have a truly unique and beautiful item in your jewelry collection. Thank you for looking and have a nice day! - Lottie :) \xC2\xA9 Lottie's Trinkets 2005 - 2011 - All Rights Reserved Ref LT Layered Coral"
  }
  product9.update_attributes(description: desc)
end
