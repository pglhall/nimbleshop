PaypalExtension::Engine.routes.draw do
  resource :paypal do
    collection do
      get :notify
    end
  end
end
