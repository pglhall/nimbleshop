Nimbleshop::Application.routes.draw do

  themes_for_rails

  get "/pages/about-us",           to: "pages#about_us",   as: :about_us
  get "/pages/contact-us",         to: "pages#contact_us", as: :contact_us

  resources :payment_processors
  resources :product_groups
  resources :pages,     only: :show
  resource  :checkout, controller: 'checkout',  only: :show

  resources :instant_payment_notifications do
    collection do
      post 'paypal'
      post 'splitable'
    end
  end

  resources :products,  only: [:index, :show] do
    member do
      get 'all_pictures'
    end
  end

  resources :orders,    only: [:edit, :update] do
    member do
      get 'cancel'
      get 'edit_shipping_method'
      put 'update_shipping_method'
    end
  end

  match 'orders/:id/:payment_method' => 'orders#paid', as: :paid_order

  resource  :feedback,  only: [:show] do
    collection do
      get 'splitable'
    end
  end

  resource :cart, only: [:show, :update] do
    member do
      post 'add'
    end
  end

  get "/admin",           to: "admin/main#index"
  get "/reset",           to: "admin/main#reset"
  get "/paypal_return",   to: "paypal_return#handle"

  root :to => "products#index"

  # BEGINNING of Admin section ---------------------------------------------------
  namespace :admin do
    namespace :paymentmethod do
      resource :authorizedotnet
      resource :paypalwebsite_payments_standard
      resource :splitable
    end
    resources :payment_methods

    resources :orders do
      resources :shipments, except: [:edit, :update]
    end

    resources :country_shipping_zones, :controller => 'shipping_zones' do
      resources :shipping_methods
    end

    resources :regional_shipping_zones, :controller => 'shipping_zones' do
      resources :shipping_methods do
        member do
          put :update_offset
          put :disable
          put :enable
        end
      end
    end

    resources :shipping_zones do
      resources :shipping_methods
    end

    resource  :payment_gateway
    resources :products do
      member do
        put 'variants'
      end
    end
    resources :product_groups
    resources :custom_fields

    resources :link_groups do
      resources :navigations, only: [:create, :new, :destroy] 
    end

    resource  :shop, only: [:update, :edit]
  end

  # END of Admin section ---------------------------------------------------

end
