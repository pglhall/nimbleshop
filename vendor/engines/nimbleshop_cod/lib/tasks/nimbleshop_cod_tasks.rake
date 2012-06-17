desc 'load cash on delivery record'
namespace :nimbleshop_cod do
  task :load_record => :environment do

    if NimbleshopCod::Cod.find_by_permalink('cash-on-delivery')
      puts "Cod record already exists"
    else
      NimbleshopCod::Cod.create!(
        {
          name: 'Cash on delivery',
          permalink: 'cash-on-delivery'
        })
        puts "Cash on delivery record was successfuly created"
    end

  end
end

