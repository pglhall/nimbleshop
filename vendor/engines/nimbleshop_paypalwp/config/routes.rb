NimbleshopPaypalwp::Engine.routes.draw do
  resource :paypalwp do
    collection do
      get :notify
    end
  end
end
