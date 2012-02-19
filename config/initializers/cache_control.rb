if Settingg.using_heroku
  config.serve_static_assets = true

  # cache images for 1 hour
  config.static_cache_control = "public, max-age=3600"
end
