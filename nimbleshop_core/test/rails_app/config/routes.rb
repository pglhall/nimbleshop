Rails.application.routes.draw do

    mount NimbleshopSimply::Engine,          :at => '/'

    mount NimbleshopAuthorizedotnet::Engine, :at => '/nimbleshop_authorizedotnet'
    mount NimbleshopPaypalwp::Engine,        :at => '/nimbleshop_paypalwp'
    mount NimbleshopSplitable::Engine,       :at => '/nimbleshop_splitable'
    mount NimbleshopCod::Engine,             :at => '/nimbleshop_cod'

end
