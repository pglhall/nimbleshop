Nimbleshop::Application.routes.draw do

  namespace :admin do
    namespace :paymentmethod do
      resource :authorizedotnet
      resource :paypalwebsite_payments_standard
      resource :splitable
    end
    resources :payment_methods

    resources :orders
    resources :shipping_zones do
      resources :shipping_methods
    end
    resource  :payment_gateway
    resources :products
    resources :product_groups
    resources :custom_fields
    resources :link_groups
    resource  :shop, only: [:update, :edit]
  end

  resources :creditcard_payments
  resources :payment_notifications do
    collection do
      post 'paypal'
      post 'splitable'
    end
  end
  resources :product_groups
  resources :products,  only: [:index, :show] do
    member do
      get 'all_pictures'
    end
  end
  resources :pages,     only: [:show]
  resources :orders,    only: [:edit, :update] do
    member do
      get 'paid_using_creditcard'
      get 'edit_shipping_method'
      put 'update_shipping_method'
    end
  end
  resource  :checkout, :controller => 'checkout',  :only => [:show]
  resource  :feedback,  only: [:show] do
    collection do
      get 'splitable'
    end
  end

  resource :cart do
    member do
      post 'add'
    end
  end

  get "/admin",    :to => "admin/main#index"
  get "/reset",    :to => "admin/main#reset"

  get "/paypal_return",    :to => "paypal_return#handle"

  root :to => "products#index"

end
