Nimbleshop::Application.routes.draw do

  mount NimbleshopAuthorizedotnet::Engine, at: '/admin/payment_methods/nimbleshop_authorizedotnet',
                                           as: 'nimbleshop_authorizedotnet'

  mount NimbleshopPaypalwp::Engine,        at: '/admin/payment_methods/nimbleshop_paypalwp',
                                           as: 'nimbleshop_paypalwp'

  mount NimbleshopSplitable::Engine,       at: '/admin/payment_methods/nimbleshop_splitable',
                                           as: 'nimbleshop_splitable'


  themes_for_rails

  get "/pages/about-us",           to: "pages#about_us",   as: :about_us
  get "/pages/contact-us",         to: "pages#contact_us", as: :contact_us

  resources :payment_processors
  resources :product_groups
  resources :products,  only: [:index, :show]

  resources :orders,    only: [:show, :edit, :update] do
    member do
      get :cancel

      # TODO change the name to choose_shipping_method. current name edit_shipping_method suggests that we are editing shipping_method
      # while we are editing order
      get :edit_shipping_method

      # TODO change the name to something like  chosen_shipping_method
      put :update_shipping_method
    end
  end

  resource  :feedback,  only: [:show] do
    collection do
      get :splitable
    end
  end

  resource :cart, only: [:show, :update] do
    member do
      post :add
    end
  end

  get "/admin",           to: "admin/main#index"
  get "/paypal_return",   to: "paypal_return#handle"

  root :to => "products#index"

  # BEGINNING of Admin section ---------------------------------------------------
  namespace :admin do

    resource  :shop, only: [:update, :edit]
    resources :payment_methods
    resources :product_groups
    resources :custom_fields

    resources :orders do
      resources :shipments, except: [:edit, :update]
    end

    resources :country_shipping_zones, controller: :shipping_zones do
      resources :shipping_methods
    end

    resources :regional_shipping_zones, controller: :shipping_zones do
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
        put :variants
      end
    end

    resources :link_groups do
      resources :navigations, only: [:create, :new, :destroy] 
    end

  end
  # END of Admin section ---------------------------------------------------

end
