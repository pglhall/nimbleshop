desc "sets up environment"
task :setup => :environment do

 raise "this task should not be run in production" if Rails.env.production?

  Rake::Task["db:reset"].invoke
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
