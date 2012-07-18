NimbleshopSimply::Engine.routes.draw do

  get "/pages/about-us",           to: "pages#about_us",   as: :about_us
  get "/pages/contact-us",         to: "pages#contact_us", as: :contact_us

  resources :product_groups, only: [:show]
  resources :products,  only: [:index, :show]

  resources :orders,  only: :show

  namespace :checkout do
    resource :shipping_address
    resource :shipping_method
    resource :payment
  end

  resource :cart, only: [:show, :update] do
    member do
      post :add
      get :checkingout
    end
  end

end
