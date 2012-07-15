module Nimbleshop
  class Engine < ::Rails::Engine

    engine_name 'nimbleshop_core'

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/nimbleshop)

    config.to_prepare do
      Address
      ShippingZone
    end

    initializer 'nimbleshop_core.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper AdminHelper
        helper NimbleshopHelper
        helper PaymentMethodHelper
      end
    end

  end
end
