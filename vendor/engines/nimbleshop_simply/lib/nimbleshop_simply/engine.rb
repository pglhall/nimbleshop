module NimbleshopSimply
  class Engine < ::Rails::Engine

    isolate_namespace NimbleshopSimply

    initializer 'nimbleshop_simpley.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        #helper NimbleshopSimply::ExposedHelper
      end
    end

  end
end
