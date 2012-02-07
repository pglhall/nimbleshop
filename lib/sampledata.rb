class Sampledata
  attr_accessor :product1, :product2, :product3, :product4, :product5, :product6, :product7

  def process_link_group
    link_group = LinkGroup.create!(name: 'Main-nav')
    link_home = Link.create!(name: 'Home', url: '/')
    Navigation.create!(link_group: link_group, navigeable: link_home)
  end

  def load_shop
      Shop.create!( name:           'nimbleshopdemo',
                   theme:           'nootstrap',
                   phone_number:    '800-456-7890',
                   contact_email:   'johnnie.walker@nimbleshop.com',
                   twitter_handle:  '@nimbleshop',
                   intercept_email: 'johnnie.walker@nimbleshop.com',
                   from_email:      'support@nimbleshop.com',
                   gateway:         'AuthorizeNet',
                   facebook_url:    'http://www.facebook.com/pages/NimbleSHOP/119319381517845')
  end

  def process_pictures
    puts "processing pictures. Might take a while ...."
    process_picture('pic1_1.jpg', product1)
    process_picture('pic2_1.jpg', product2)
    process_picture('pic2_2.jpg', product2)
    process_picture('pic3_1.jpg', product3)
    process_picture('pic3_2.jpg', product3)
    process_picture('pic4_1.jpg', product4)
    process_picture('pic4_2.jpg', product4)
    process_picture('pic4_3.jpg', product4)
    process_picture('pic5_1.jpg', product5)
    process_picture('pic5_2.jpg', product5)
    process_picture('pic5_3.jpg', product5)
    process_picture('pic6_1.jpg', product6)
    process_picture('pic6_2.jpg', product6)
    process_picture('pic6_3.jpg', product6)
    process_picture('pic7_1.jpg', product7)
    process_picture('pic7_2.jpg', product7)
    process_picture('pic7_3.jpg', product7)
  end

  class FilelessIO < StringIO
    attr_accessor :original_filename
  end
  def process_picture(filename, product)
    img = File.open(Rails.root.join('db', 'original_pictures', filename )) {|i| i.read}
    encoded_img = Base64.encode64 img
    io = FilelessIO.new(Base64.decode64(encoded_img))
    io.original_filename = filename
    p = Picture.new
    p.product = product
    p.picture = io
    p.save
  end

  def load_price_information
    cf = CustomField.create!(name: 'original price', field_type: 'number')

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
    product5.custom_field_answers.create(custom_field: cf, value: 'bracelet')
    product1.custom_field_answers.create(custom_field: cf, value: 'bracelet')
    product2.custom_field_answers.create(custom_field: cf, value: 'bracelet')
    product7.custom_field_answers.create(custom_field: cf, value: 'earring')
    product4.custom_field_answers.create(custom_field: cf, value: 'earring')
    product6.custom_field_answers.create(custom_field: cf, value: 'necklace')
    product3.custom_field_answers.create(custom_field: cf, value: 'necklace')

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
    self.product1 = Product.create!( title: "Howlite and Crystal Flower Bracelet", price: 10, description: 'tbd')
    product1.update_attributes!(variants_enabled: true)
    product1.variation1.update_attributes!(active: true)
    product1.variation2.update_attributes!(active: true)
    product1.variants.create!(variation1_value: 'Black',  variation2_value: 'Small',  price: 11)
    product1.variants.create!(variation1_value: 'White',  variation2_value: 'Small',  price: 111)
    product1.variants.create!(variation1_value: 'Black',  variation2_value: 'Medium', price: 21)
    product1.variants.create!(variation1_value: 'White',  variation2_value: 'Medium', price: 121)
    product1.variants.create!(variation1_value: 'Black',  variation2_value: 'Large', price:   31)
    product1.variants.create!(variation1_value: 'White',  variation2_value: 'Large', price: 131)


    self.product2 = Product.create!( title: "Candy Colours Bracelet Set", price: 47, description: 'tbd')

    self.product3 = Product.create!( title: "Gemstone Cross Necklaces", price: 78, description: 'tbd')

    self.product4 = Product.create!( title: "Large Sterling Silver Hoop Earrings Aqua Freshwater Pearls Moonstone Hammered",
                                price: 81,
                                description: 'tbd')

    self.product5 = Product.create!( title: "Red, Black & Silver Glass Bracelet", price: 107, description: 'tbd')

    self.product6 = Product.create!( title: "Layered Coral Necklace", price: 137, description: 'tbd')

    self.product7 = Product.create!( title: "Claddagh Earrings", price: 141, description: 'tbd')
  end

  def load_products_desc

    desc = "This lovely elastic bracelet is made of dyed turquoise Howlite flowers and champagne colored crystals. It is fun and goes with any outfit!  A bracelet is an article of jewelry which is worn around the wrist. Bracelets can be manufactured from metal, leather, cloth, plastic or other materials and sometimes contain jewels, rocks, wood, and/or shells. Bracelets are also used for medical and identification purposes, such as allergy bracelets and hospital patient-identification tags."
    product1.update_attributes(description: desc)

    desc = "acrylic stretch beaded bracelets with peace sign, butterfly and heart charms. A bracelet is an article of jewelry which is worn around the wrist. Bracelets can be manufactured from metal, leather, cloth, plastic or other materials and sometimes contain jewels, rocks, wood, and/or shells. Bracelets are also used for medical and identification purposes, such as allergy bracelets and hospital patient-identification tags."
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
        "Deep red oval faceted beads with clear glass rondelles with red and black stripes. I added some silver plated \"Turkish knot\" spacers and some clear silver edged Czech glass table cut beads.

          This one is 7 3/4\" or 19cm long This item is handmade by myself and is totally original in design and is the only one that will ever be made, so if you decide to own this item, you will have a truly unique and beautiful item in your jewelry collection. Thank you for looking and have a nice day! - Lottie :) \xC2\xA9 Lottie's Trinkets 2005 - 2011 - All Rights Reserved Ref LT Red Stripe"
    }
    product5.update_attributes(description: desc)


    desc = %q{
          These earrings have Irish claddagh silver charms dangling from wire wrapped erinite green Swarovski crystals and silver beads, hanging from silver earwires.

          The length is 1 5/8" from the earwire loop. The claddagh symbol is two hands gently holding a crowned heart.
    }
    product6.update_attributes(description: desc)

    desc = %q{
        "Simple layered necklace made from \"farmed\" coral (sustainable). I spaced the beds with gold plated daisy spacers and then added some simple gold plated chain to give the desired length. \r\n\
          \r\n\
          This one 21\" or 53cm long This item is handmade by myself and is totally original in design and is the only one that will ever be made, so if you decide to own this item, you will have a truly unique and beautiful item in your jewelry collection. Thank you for looking and have a nice day! - Lottie :) \xC2\xA9 Lottie's Trinkets 2005 - 2011 - All Rights Reserved Ref LT Layered Coral"
    }
    product7.update_attributes(description: desc)
  end

end
