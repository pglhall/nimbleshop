NimbleshopAuthorizedotnet::Engine.routes.draw do
  resource :authorizedotnet do
    member do
      post :make_payment
    end
  end
end
