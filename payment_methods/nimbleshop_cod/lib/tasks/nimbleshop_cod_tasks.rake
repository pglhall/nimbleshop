namespace :nimbleshop_cod do

  desc 'load cash on delivery record'
  task :load_record => :environment do

    if NimbleshopCod::Cod.find_by_permalink('cash-on-delivery')
      puts "Cod record already exists"
    else
      NimbleshopCod::Cod.create!( { name: 'Cash on delivery', permalink: 'cash-on-delivery' })
        puts "Cash on delivery record was successfuly created"
    end
  end

  desc 'copies images from engine to main rails application'
  task :copy_images do
    engine_name = 'nimbleshop_cod'
    origin = File.expand_path('../../app/assets/images', File.dirname(__FILE__))
    destination = Rails.root.join('app', 'assets', 'images', 'engines', engine_name)
    FileUtils.mkdir_p(destination) if !File.exist?(destination)
    Dir[File.join(origin, '**/*')].each { |file| FileUtils.cp(file, File.join(destination) ) unless File.directory?(file) }
  end

end
