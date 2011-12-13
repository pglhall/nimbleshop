Nimbleshop::Application.routes.draw do

  namespace :admin do
    resources :orders
    resources :payment_methods
    resources :shipping_zones
    resources :shipping_methods
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
  resources :products,  only: [:index, :show]
  resources :pages,     only: [:show]
  resources :orders,    only: [:edit, :update] do
    member do
      get 'paid_using_cc'
    end
    resource :shipping_method
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
