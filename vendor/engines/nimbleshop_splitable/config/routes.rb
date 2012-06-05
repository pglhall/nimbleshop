NimbleshopSplitable::Engine.routes.draw do
  resource :splitable do
    collection do
      post :notify
    end
  end
  resource :payment
end
