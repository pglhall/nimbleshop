if Settings.using_heroku
  Nimbleshop::Application.config.serve_static_assets = true

  # cache images for 1 hour
  Nimbleshop::Application.config.static_cache_control = "public, max-age=3600"
end
