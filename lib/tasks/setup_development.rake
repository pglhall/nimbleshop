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

  sampledata = Sampledata.new
  sampledata.load_products

  PaymentMethod.load_default!

  sampledata.load_shop

  sampledata.load_price_information
  sampledata.load_category_information

  PaymentMethod.update_all(enabled: true)

  sampledata.load_shipping_methods

  sampledata.load_products_desc
  sampledata.process_pictures

end
