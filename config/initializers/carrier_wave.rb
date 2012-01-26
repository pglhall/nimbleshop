if Rails.env.development?

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end

elsif Rails.env.test?

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

elsif Rails.env.staging? || Rails.env.production?

  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage = :file
    config.enable_processing = true

    config.s3_access_key_id = Settings.s3.access_key_id
    config.s3_secret_access_key = Settings.s3.secret_access_key
    config.s3_bucket = Settings.s3.bucket_name
  end

else

  raise "carrierwave is not configured for #{Rails.env}"

end
