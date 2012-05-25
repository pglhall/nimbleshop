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

  get "/paypal_return",   to: "paypal_return#handle"

