Nimbleshop::Application.routes.draw do

  mount NimbleshopAuthorizedotnet::Engine, at: '/admin/payment_methods/nimbleshop_authorizedotnet',
                                           as: 'nimbleshop_authorizedotnet'

  mount NimbleshopPaypalwp::Engine,        at: '/admin/payment_methods/nimbleshop_paypalwp',
                                           as: 'nimbleshop_paypalwp'

  mount NimbleshopSplitable::Engine,       at: '/admin/payment_methods/nimbleshop_splitable',
                                           as: 'nimbleshop_splitable'

end
