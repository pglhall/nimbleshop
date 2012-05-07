class Sampledata

  attr_accessor :products

  def populate
    load_products
    load_shop
    load_price_information
    load_category_information
    load_shipping_methods
    load_products_desc
    process_pictures
  end

  def load_shop
      Shop.create!( name:           'nimbleShop',
                   theme:           'nootstrap',
                   phone_number:    '800-456-7890',
                   contact_email:   'johnnie.walker@nimbleshop.com',
                   twitter_handle:  '@nimbleshop',
                   intercept_email: 'johnnie.walker@nimbleshop.com',
                   from_email:      'support@nimbleshop.com',
                   gateway:         'AuthorizeNet',
                   tax_percentage: 1.23,
                   google_analytics_tracking_id: Settings.google_analytics_tracking_id,
                   facebook_url:    'http://www.facebook.com/pages/NimbleSHOP/119319381517845')
  end

  def process_pictures
    puts "processing pictures. Might take a while ...."

    products.each_with_index do |product, index|
      handle_pictures_for_product(product, "product#{index+1}")
    end
  end

  def handle_pictures_for_product(product, dirname)
    pictures = Dir.glob(Rails.root.join('db', 'original_pictures', dirname, '*'))

    pictures.sort.each do |filename|
      attach_picture( filename, product)
    end
  end

  def attach_picture(filename_with_extension, product)
    path = Rails.root.join('db', 'original_pictures', filename_with_extension)
    product.attach_picture(filename_with_extension, path)
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
    Navigation.create!(link_group: link_group, product_group: pg_lt_50)
    Navigation.create!(link_group: link_group, product_group: pg_between_50_100)
    Navigation.create!(link_group: link_group, product_group: pg_gt_100)
  end

  def load_category_information
    cf = CustomField.create!(name: 'category', field_type: 'text')
    products[0].custom_field_answers.create(custom_field: cf, value: 'art')
    products[1].custom_field_answers.create(custom_field: cf, value: 'toy')
    products[2].custom_field_answers.create(custom_field: cf, value: 'fashion')
    products[3].custom_field_answers.create(custom_field: cf, value: 'food')
    products[4].custom_field_answers.create(custom_field: cf, value: 'fashion')
    products[5].custom_field_answers.create(custom_field: cf, value: 'fashion')
    products[6].custom_field_answers.create(custom_field: cf, value: 'fashion')
    products[7].custom_field_answers.create(custom_field: cf, value: 'toy')
    products[8].custom_field_answers.create(custom_field: cf, value: 'fashion')

    pg_food = ProductGroup.create!(name: 'Food')
    pg_food.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'food')

    pg_toy = ProductGroup.create!(name: 'Toy')
    pg_toy.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'toy')

    pg_art = ProductGroup.create!(name:  'Art')
    pg_art.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'art')

    pg_fashion = ProductGroup.create!(name: 'Fashion')
    pg_fashion.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'fashion')

    link_group = LinkGroup.create!(name: 'Shop by category')
    link_group.navigations.create(product_group: pg_toy)
    link_group.navigations.create(product_group: pg_art)
    link_group.navigations.create(product_group: pg_food)
    link_group.navigations.create(product_group: pg_fashion)
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
    self.products = []

    products << Product.create!( title: "Beautiful portrait of Tajmahal", price: 19, description: 'tbd', status: 'active')
    products << Product.create!( title: "Set of three barbies", price: 47, description: 'tbd', status: 'active')
    products << Product.create!( title: "Coin Bracelet", price: 78, description: 'tbd', status: 'active')
    products << Product.create!( title: "Indian mangoes basket", price: 81, description: 'tbd', status: 'active')
    products << Product.create!( title: "Simple bag", price: 107, description: 'tbd', status: 'active')

    product = Product.create!( title: "Handmade bangles", price: 11, description: 'tbd', status: 'active')
    products << product
    product.update_attributes!(variants_enabled: true)
    product.variation1.update_attributes!(active: true)
    product.variation2.update_attributes!(active: true)

    product.variants.create!(variation1_value: 'Pink',   variation2_value: 'Small',  price: 19)
    product.variants.create!(variation1_value: 'Yellow', variation2_value: 'Small',  price: 11)
    product.variants.create!(variation1_value: 'Blue',   variation2_value: 'Small',  price: 11)
    product.variants.create!(variation1_value: 'Orangy', variation2_value: 'Small',  price: 14)

    product.variants.create!(variation1_value: 'Pink',   variation2_value: 'Medium',  price: 39)
    product.variants.create!(variation1_value: 'Yellow', variation2_value: 'Medium',  price: 31)
    product.variants.create!(variation1_value: 'Blue',   variation2_value: 'Medium',  price: 31)
    product.variants.create!(variation1_value: 'Orangy', variation2_value: 'Medium',  price: 34)

    products << Product.create!( title: "Colorful shoes", price: 191, description: 'tbd')
    products << Product.create!( title: "Battery operated Mercedes SL 6V car in red", price: 111, description: 'tbd')
    products << Product.create!( title: "Set of six tea cups", price: 41, description: 'tbd')
  end

  def load_products_desc
    descriptions = []

    desc_0 = %q{
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
    }
    descriptions << desc_0

    desc_1 = %q{
      Barbies are lovely.
    }
    descriptions << desc_1

    desc_2 = %q{
      Bracelet made from turqoise magnesite coin beads, smooth and sensual.
      }
    descriptions << desc_2

    desc_3 = %q{
              The mango is the national fruit of India and Pakistan. It is also the national fruit in the Philippines. The mango tree is the national tree of Bangladesh.

              In Hinduism, the perfectly ripe mango is often held by Lord Ganesha as a symbol of attainment, regarding the devotees potential perfection. 
              Mango blossoms are also used in the worship of the goddess Saraswati. No Telugu/Kannada new year's day called Ugadi passes without eating 
              ugadi pacchadi made with mango pieces as one of the ingredients. In Tamil Brahmin homes mango is an ingredient in making vadai paruppu on 
              Sri Rama Navami day (Lord Ram's Birth Day) and also in preparation of pachchadi on Tamil new year's day.
              The Jain goddess Ambika is traditionally represented as sitting under a mango tree.

              An image of Ambika under a mango tree in Cave of the Ellora Caves
              Mango leaves are used to decorate archways and doors in Indian houses and during weddings and celebrations like Ganesh Chaturthi. 
              Mango motifs and paisleys are widely used in different Indian embroidery styles, and are found in Kashmiri shawls, Kanchipuram silk sarees, etc. Paisleys are also common to Iranian art, because of its pre-Islamic Zoroastrian past.
    }
    descriptions << desc_3

    desc_4 = %q{
      It is also a simple design. Sometime just being simple makes you stand out. No need to have a bag that is screaming "save the earth". If you carry this bag then it means you stand for all that and much more.
    }
    descriptions << desc_4

    desc_5 = %q{
Bangles are part of traditional Indian jewelry. They are usually worn in pairs by women, one or more on each arm. Most Indian women prefer wearing either gold or glass bangles or combination of both. Inexpensive bangles made from plastic are slowly replacing those made by glass, but the ones made of glass are still preferred at traditional occasions such as marriages and on festivals.

The designs range from simple to intricate handmade designs, often studded with precious and semi-precious stones such as diamonds, gems and pearls. Sets of expensive bangles made of gold and silver make a jingling sound. The imitation jewelry, tend to make a tinny sound when jingled.

It is tradition that the bride will try to wear as many small glass bangles as possible at her wedding and the honeymoon will end when the last bangle breaks.

    }
    descriptions << desc_5

    desc_6 = %q{
      People of India love color. Everything they use from top to bottom is colorful.

      Lets talk about shoes. Making good looking shoes is an art they have perfected over centuries. Making a shoe takes the whole village. And the whole village participates in the business of making and selling quality colorful shoes.
    }
    descriptions << desc_6

    desc_7 = %q{
      Speedy cars.
    }
    descriptions << desc_7

    desc_8 = %q{
      "It's tea time. Grab your cup"
    }
    descriptions << desc_8

    products.each_with_index do |product, i|
      product.update_attributes!(description: descriptions[i])
    end

  end

end
