# This is a rake task that simulates what splitable will POST as callback.
#

desc "sends callback"

namespace :nimbleshop_splitable do
task :mock_callback => :environment do

  unless order_number = ENV['order_number']
    puts "Usage: rake mock_callcak order_number=xxxxxxx"
    abort
  end

  base_url = 'http://localhost:3000'
  endpoint = base_url + '/nimbleshop_splitable/splitable/notify'


  params = {  invoice: order_number,
              payment_status: "cancelled", 
              api_secret: "540f0849518d83d6", 
              transaction_id: "49c380175f3c5603287698a4" }

    require "net/http"
    require "uri"
    uri = URI.parse(endpoint)
    response = Net::HTTP.post_form(uri, params)

  end
end
