namespace :ns do
  task :dump_data do
    FileUtils.rm_rf(Rails.root.join('db', 'data'))
    ENV['dir'] = 'data'
    Rake::Task["db:data:dump_dir"].invoke
    dir = Rails.root.join('db', 'data')

    Dir.foreach(dir) do |i|
      if (i =~ /yml/) && !['pictures.yml', 'creditcards.yml'].include?(i)
        FileUtils.rm( Rails.root.join('db', 'data', i ))
      end
    end
  end

  task :load_data do
    ENV['dir'] = 'data'
    Rake::Task["db:data:load_dir"].invoke
  end
end

task :process_pictures => :environment do
  class FilelessIO < StringIO
      attr_accessor :original_filename
  end
  img = File.open(Rails.root.join('public', 'pictures', 'original', 'cws.png' )) {|i| i.read}
  encoded_img = Base64.encode64 img
  io = FilelessIO.new(Base64.decode64(encoded_img))
  io.original_filename = "cws.png"
  p = Picture.new
  p.product = Product.first
  p.picture = io
  p.save
end

desc "sets up local development environment"
task :setup_development => :environment do

  if Settings.using_heroku
    #system "heroku pg:reset SHARED_DATABASE_URL --confirm chickscorner-staging"
    #Rake::Task["db:migrate"].invoke
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

  sampledata = Sampledata.new
  sampledata.load_products

  PaymentMethod.load_default!

  shop = Shop.create!( name: 'chickscorner',
                       theme: 'nootstrap',
                       phone_number: '800-456-7890',
                       contact_email: 'johnnie.walker@nimbleshop.com',
                       twitter_handle: '@nimbleshop',
                       intercept_email: 'johnnie.walker@nimbleshop.com',
                       from_email:      'support@nimbleshop.com',
                       gateway: 'AuthorizeNet',
                       facebook_url: 'http://www.facebook.com/pages/NimbleSHOP/119319381517845')

  link_group = LinkGroup.create!(name: 'Main-nav')
  link_home = Link.create!(name: 'Home', url: '/')
  Navigation.create!(link_group: link_group, navigeable: link_home)

  sampledata.load_price_information
  sampledata.load_category_information

  PaymentMethod.update_all(enabled: true)

  sampledata.load_shipping_methods

  sampledata.load_products_desc
  sampledata.process_pictures

end
