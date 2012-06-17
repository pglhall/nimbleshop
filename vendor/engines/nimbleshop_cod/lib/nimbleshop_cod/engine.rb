module NimbleshopCod
  class Engine < ::Rails::Engine

    isolate_namespace NimbleshopCod

    config.to_prepare do
      ::NimbleshopCod::Cod
    end

    initializer 'nimbleshop_cod_engine.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper NimbleshopCod::ExposedHelper
      end
    end

  end
end
