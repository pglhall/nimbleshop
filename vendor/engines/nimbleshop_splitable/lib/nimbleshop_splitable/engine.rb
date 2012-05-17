module NimbleshopSplitable
  class Engine < ::Rails::Engine
    isolate_namespace NimbleshopSplitable

    initializer 'nimbleshop_splitable_engine.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper NimbleshopSplitable::ExposedHelper
      end
    end

  end
end
