if Settings.use_s3

  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage = :fog
    config.enable_processing = true
    config.fog_directory  = Settings.s3.bucket_name
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.fog_public     = true

    config.fog_credentials = {
        provider:               'AWS',
        aws_access_key_id:      Settings.s3.access_key_id,
        aws_secret_access_key:  Settings.s3.secret_access_key,
        region:                 'us-east-1'
      }
  end

else

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end

end

