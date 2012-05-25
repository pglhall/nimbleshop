  themes_for_rails

  get "/reset",                    to: "carts#reset"
  get "/pages/about-us",           to: "pages#about_us",   as: :about_us
  get "/pages/contact-us",         to: "pages#contact_us", as: :contact_us

  resources :payment_processors
  resources :product_groups
  resources :products,  only: [:index, :show]

  resources :orders,    only: [:show, :edit, :update] do
    namespace :checkout do
      resource :shipping_address
      resource :shipping_method
    end
    member do
      get :cancel
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

