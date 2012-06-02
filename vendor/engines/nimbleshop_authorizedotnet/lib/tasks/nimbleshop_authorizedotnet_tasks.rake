desc 'load Authorize.net record'
namespace :nimbleshop_authorizedotnet do
  task :load_record => :environment do
    NimbleshopAuthorizedotnet::Authorizedotnet.create!(
      {
        login_id: Settings.authorizedotnet.login_id,
        transaction_key: Settings.authorizedotnet.transaction_key,
        company_name_on_creditcard_statement: 'Nimbleshop LLC',
        name: 'Authorize.net',
        permalink: 'authorizedotnet',
        description: %Q[<p> Authorize.Net is a payment gateway service provider allowing merchants to accept credit card and electronic checks paymentsn. Authorize.Net claims a user base of over 305,000 merchants, which would make them the Internet's largest payment gateway service provider.  </p> <p> It also provides an instant test account which you can use while your application is being processed.  </p>]
      })
  end
end
