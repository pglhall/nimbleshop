module NimbleshopSimply
  class Engine < ::Rails::Engine

    isolate_namespace NimbleshopSimply

    initializer 'nimbleshop_simply.precompile_assets' do |config|
      Rails.application.config.assets.precompile += %w( nimbleshop_simply/simply.css )
      Rails.application.config.assets.precompile += %w( nimbleshop_simply/simply.js )
    end

  end
end
