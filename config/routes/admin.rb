  get "/admin",           to: "admin/main#index"
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
    resources :products

    resources :link_groups do
      resources :navigations, only: [:create, :new, :destroy] 
    end

  end
