if Settings.cache_images
  # cache images
  Nimbleshop::Application.config.static_cache_control = "public, max-age=36000"
end
