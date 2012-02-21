class Sampledata
  attr_accessor :product1, :product2, :product3, :product4, :product5, :product6, :product7

  def load_shop
      Shop.create!( name:           'nimbleShop',
                   theme:           'nootstrap',
                   phone_number:    '800-456-7890',
                   contact_email:   'johnnie.walker@nimbleshop.com',
                   twitter_handle:  '@nimbleshop',
                   intercept_email: 'johnnie.walker@nimbleshop.com',
                   from_email:      'support@nimbleshop.com',
                   gateway:         'AuthorizeNet',
                   google_analytics_tracking_id: ENV['GOOGLE_ANALYTICS_TRACKING_ID'],
                   facebook_url:    'http://www.facebook.com/pages/NimbleSHOP/119319381517845')
  end

  def process_pictures
    puts "processing pictures. Might take a while ...."
    process_picture('pic1_1.jpg', product1)
    process_picture('pic2_1.jpeg', product2)
    process_picture('pic2_2.jpeg', product2)
    process_picture('pic3_1.jpg', product3)
    process_picture('pic3_2.jpg', product3)
    process_picture('pic4_1.jpg', product4)
    process_picture('pic4_2.jpg', product4)
    process_picture('pic4_3.jpg', product4)
    process_picture('pic5_1.jpeg', product5)
    process_picture('pic5_2.jpeg', product5)
    process_picture('pic5_3.jpeg', product5)

    process_picture('pic6_1.jpg', product6)
    process_picture('pic6_2.jpg', product6)
    process_picture('pic6_3.jpg', product6)
    process_picture('pic6_4.jpg', product6)
    process_picture('pic6_5.jpg', product6)
    process_picture('pic6_6.jpg', product6)
    process_picture('pic6_7.jpg', product6)
    process_picture('pic6_8.jpg', product6)
    process_picture('pic6_9.jpg', product6)
    process_picture('pic6_10.jpg', product6)
    process_picture('pic6_11.jpg', product6)
    process_picture('pic6_12.jpg', product6)
    process_picture('pic6_13.jpg', product6)
    process_picture('pic6_14.jpg', product6)
    process_picture('pic6_15.jpg', product6)
    process_picture('pic6_16.jpg', product6)
    process_picture('pic6_17.jpg', product6)

    process_picture('pic7_1.jpg', product7)
    process_picture('pic7_2.jpg', product7)
    process_picture('pic7_3.jpg', product7)
  end

  def process_picture(filename, product)
    path = Rails.root.join('db', 'original_pictures', filename )
    product.attach_picture(filename, path)
  end

  def load_price_information
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
  end

  def load_category_information
    cf = CustomField.create!(name: 'category', field_type: 'text')
    product1.custom_field_answers.create(custom_field: cf, value: 'art')
    product2.custom_field_answers.create(custom_field: cf, value: 'fashion')
    product3.custom_field_answers.create(custom_field: cf, value: 'rug')
    product4.custom_field_answers.create(custom_field: cf, value: 'fashion')
    product5.custom_field_answers.create(custom_field: cf, value: 'fashion')
    product6.custom_field_answers.create(custom_field: cf, value: 'fashion')
    product7.custom_field_answers.create(custom_field: cf, value: 'fashion')

    pg_rug = ProductGroup.create!(name: 'Rug')
    pg_rug.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'rug')
    pg_art = ProductGroup.create!(name:  'Art')
    pg_art.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'art')
    pg_fashion = ProductGroup.create!(name: 'Fashion')
    pg_fashion.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'fashion')

    link_group = LinkGroup.create!(name: 'Shop by category')
    link_group.navigations.create(navigeable: pg_rug)
    link_group.navigations.create(navigeable: pg_art)
    link_group.navigations.create(navigeable: pg_fashion)
  end

  def load_shipping_methods
    sz = CountryShippingZone.create!(country_code: 'US')
    ShippingMethod.create!(name: 'Ground shipping', base_price: 10, shipping_zone_id: sz.id,
                           lower_price_limit: 10, upper_price_limit: 999999)

    ShippingMethod.create!(name: 'Express shipping', base_price: 30, shipping_zone_id: sz.id,
                           lower_price_limit: 10, upper_price_limit: 999999)

    return
    ShippingMethod.create!(name: 'Ground shipping', base_price: 10, shipping_zone_id: sz.id,
                           lower_price_limit: 10, upper_price_limit: 20)
    ShippingMethod.create!(name: 'Ground shipping', base_price: 20, shipping_zone_id: sz.id,
                           lower_price_limit: 20)

    ShippingMethod.create!(name: 'Express shipping', base_price: 15, shipping_zone_id: sz.id,
                           lower_price_limit: 10, upper_price_limit: 20)
    ShippingMethod.create!(name: 'Express shipping', base_price: 25, shipping_zone_id: sz.id,
                           lower_price_limit: 20)
  end

  def load_products
    self.product1 = Product.create!( title: "Tajmahal - crown of palaces", price: 10, description: 'tbd', status: 'active')

    self.product2 = Product.create!( title: "Lovely orange belt", price: 47, description: 'tbd', status: 'active')
    self.product3 = Product.create!( title: "Indian rug made with love", price: 78, description: 'tbd', status: 'active')
    self.product4 = Product.create!( title: "Sterling Silver Earrings", price: 81, description: 'tbd', status: 'active')
    self.product5 = Product.create!( title: "Simple tote bag", price: 107, description: 'tbd', status: 'active')

    self.product6 = Product.create!( title: "Handmade vibrant bangles", price: 11, description: 'tbd', status: 'active')
    product6.update_attributes!(variants_enabled: true)
    product6.variation1.update_attributes!(active: true)
    product6.variation2.update_attributes!(active: true)

    product6.variants.create!(variation1_value: 'Pink',   variation2_value: 'Small',  price: 19)
    product6.variants.create!(variation1_value: 'Yellow', variation2_value: 'Small',  price: 11)
    product6.variants.create!(variation1_value: 'Blue',   variation2_value: 'Small',  price: 11)
    product6.variants.create!(variation1_value: 'Orangy', variation2_value: 'Small',  price: 14)

    product6.variants.create!(variation1_value: 'Pink',   variation2_value: 'Medium',  price: 39)
    product6.variants.create!(variation1_value: 'Yellow', variation2_value: 'Medium',  price: 31)
    product6.variants.create!(variation1_value: 'Blue',   variation2_value: 'Medium',  price: 31)
    product6.variants.create!(variation1_value: 'Orangy', variation2_value: 'Medium',  price: 34)

    self.product7 = Product.create!( title: "Colorful rajasthani shoes", price: 141, description: 'tbd')
  end

  def load_products_desc

    desc = "
      Year of Construction: 1631
      Completed In: 1653
      Time Taken: 22 years
      Built By: Shah Jahan
      Dedicated to: Mumtaz Mahal (Arjumand Bano Begum), the wife of Shah Jahan
      Location: Agra (Uttar Pradesh), India
      Building Type: Islamic tomb
      Architecture: Mughal (Combination of Persian, Islamic and Indian architecture style)
      Architect: Ustad Ahmad Lahauri
      Cost of Construction: 32 crore rupees
      Number of workers: 20,000
      Highlights: One of the Seven Wonders of the World; A UNESCO World Heritage Site

      Facts do not capture what Tajmahal is.
    "
    product1.update_attributes(description: desc)

    desc = "Is belt a decorative item or a utilitarian item? \n

    In the armed forces of Prussia, Tsarist Russia, and other Eastern European nations, it was common for officers to wear extremely tight, wide belts around the waist, on the outside of the uniform, both to support a saber as well as for aesthetic reasons. These tightly cinched belts served to draw in the waist and give the wearer a trim physique, emphasizing wide shoulders and a pouting chest.

    This lovely orange is just what you need to make girls look at you instead of police officers.
    "
    product2.update_attributes(description: desc)

    des = %q{
        "Gorgeous gemstone cross necklace, choice of green snowflake #1, turquoise, orange jasper, amethyst, green snowflake #2, rose quartz and tiger eye.

          Cross pendants are a very personal choice for the wearer. Whether you wear one as a display of your faith, to make a fashion statement, or just because you enjoy their beauty and elegance, we have a variety of gemstone cross pendants to suit virtually any taste or budget. Each pendant features beautifully set gemstones, positioned to enhance and embellish the pendant\xE2\x80\x99s attractiveness. From semi-precious to precious gemstones, bold colors to softly muted hues, the selection of embellished crosses here have something for everyone. Choose from settings in 14k white gold, 14k yellow gold, or sterling silver. Gemstones include jade, garnet, amethyst, pearls, sapphires, diamonds, rubies, emeralds, and more. We offer a variety of sizes, from small and understated, to bold and decorative. You are sure to find whatever you are looking for in this dazzling display of artistry and craftsmanship designed to meet the needs of any budget or preference."
      }
    product3.update_attributes(description: desc)

    desc = %q{
          These large hand forged Sterling Silver hoops are comfortable and lightweight. I have lightly hammered them for shine and strength.

          The hoops are adorned with aqua Chalcedony, creamy freshwater pearls, and moonstone. All of these gorgeous stones are wrapped in Sterling Silver wire.

          All Olivia Clare jewelry is lovingly made in my Hawaiian Studio on the Big Island.
    }
    product4.update_attributes(description: desc)

    desc = %q{
      The term tote, meaning "to carry". This bag will let you carry items.

      It is also a simple design. Sometime just being simple makes you stand out. No need to have a bag that is screaming "save the earth". If you carry this bag then it means you stand for all that and much more.

      No make use of this barry and "carry" items.
    }
    product5.update_attributes(description: desc)


    desc = %q{
Bangles are part of traditional Indian jewelry. They are usually worn in pairs by women, one or more on each arm. Most Indian women prefer wearing either gold or glass bangles or combination of both. Inexpensive bangles made from plastic are slowly replacing those made by glass, but the ones made of glass are still preferred at traditional occasions such as marriages and on festivals.

The designs range from simple to intricate handmade designs, often studded with precious and semi-precious stones such as diamonds, gems and pearls. Sets of expensive bangles made of gold and silver make a jingling sound. The imitation jewelry, tend to make a tinny sound when jingled.

It is tradition that the bride will try to wear as many small glass bangles as possible at her wedding and the honeymoon will end when the last bangle breaks.

    }
    product6.update_attributes(description: desc)

    desc = %q{
      People of Rajasthan love color. Everything they use from top to bottom is colorful.

      Lets talk about shoes. Making good looking shoes is an art they have perfected over centuries. Making a shoe takes the whole village. And the whole village participates in the business of making and selling quality colorful shoes.
    }
    product7.update_attributes(description: desc)
  end

end
