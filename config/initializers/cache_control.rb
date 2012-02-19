if Settings.using_heroku
  Nimbleshop::Application.config.serve_static_assets = true

  # cache images
  Nimbleshop::Application.config.static_cache_control = "public, max-age=36000"
end
