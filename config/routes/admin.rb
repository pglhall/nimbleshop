  get "/admin",           to: "admin/main#index"

  namespace :admin do

    resource  :shop,            only: [:update, :edit]

    resource  :payment_gateway
    resources :payment_methods

    resources :products,        except: [:show]
    resources :product_groups
    resources :custom_fields

    resources :orders do
      resources :shipments,      except: [:edit, :update]
      member do
        put :capture_payment
        put :purchase_payment
      end
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

    resources :link_groups do
      resources :navigations, only: [:create, :new, :destroy] 
    end

  end
