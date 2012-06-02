desc 'load splitable record'
namespace :nimbleshop_splitable do
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
end

