module NimbleshopAuthorizedotnet
  class Engine < ::Rails::Engine
    isolate_namespace NimbleshopAuthorizedotnet

    initializer 'nimbleshop_authorizedotnet_engine.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper NimbleshopAuthorizedotnet::ExposedHelper
      end
    end

  end
end
