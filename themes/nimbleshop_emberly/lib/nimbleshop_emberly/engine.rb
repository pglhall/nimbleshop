module NimbleshopEmberly
  class Engine < ::Rails::Engine

    isolate_namespace NimbleshopEmberly

    initializer 'nimbleshop_emberly.precompile_assets' do |config|
      Rails.application.config.assets.precompile += %w( nimbleshop_emberly/simply.css )
      Rails.application.config.assets.precompile += %w( nimbleshop_emberly/emberly.js )
    end

  end
end
