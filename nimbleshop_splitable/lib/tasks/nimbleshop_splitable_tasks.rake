namespace :nimbleshop_splitable do

  desc 'load splitable record'
  task :load_record => :environment do
    if NimbleshopSplitable::Splitable.find_by_permalink('splitable')
      puts "Splitable record already exists"
    else
      NimbleshopSplitable::Splitable.create!(
        {
          api_secret: '92746e4d66cb8993',
          expires_in: 24,
          api_key: '92746e4d66cb8993',
          name: 'Splitable',
          permalink: 'splitable',
          description: %Q[<p> Splitable helps split the cost of product with friends and family.  </p> <p> <a href="http://splitable.com"> more information </a> </p>]
        })
        puts "Splitable record was successfuly created"
    end
  end

  desc 'copies images from engine to main rails application'
  task :copy_images do
    engine_name = 'nimbleshop_splitable'
    origin = File.expand_path('../../app/assets/images', File.dirname(__FILE__))
    destination = Rails.root.join('app', 'assets', 'images', 'engines', engine_name)
    FileUtils.mkdir_p(destination) if !File.exist?(destination)
    Dir[File.join(origin, '**/*')].each { |file| FileUtils.cp(file, File.join(destination) ) unless File.directory?(file) }
  end


end

