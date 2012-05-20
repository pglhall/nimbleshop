NimbleshopSplitable::Engine.routes.draw do
  resource :splitable do
    collection do
      get :notify
    end
  end
  resource :payment
end
