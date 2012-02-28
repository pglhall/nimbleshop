# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  include CarrierWave::Meta

  model_delegate_attribute :width
  model_delegate_attribute :height

  process :store_meta

  # Override the directory where uploaded files will be stored.  This is a sensible default for uploaders that are meant to be mounted .
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded
  def default_url
    "/images/no_image/" + [version_name, "no-image.png"].compact.join('_')
  end

  # Add a white list of extensions which are allowed to be uploaded.  For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  manipulation_type = :resize_to_limit

  version :tiny do
    process manipulation_type => [16, 16]
    process :store_meta
  end

  version :tiny_plus do
    process manipulation_type => [32, 32]
    process :store_meta
  end

  version :small do
    process manipulation_type => [50, 50]
    process :store_meta
  end

  version :small_plus do
    process manipulation_type => [100, 100]
    process :store_meta
  end

  version :medium do
    process manipulation_type => [160, 160]
    process :store_meta
  end

  version :medium_plus do
    process manipulation_type => [240, 240]
    process :store_meta
  end

  version :large do
    process manipulation_type => [480, 480]
    process :store_meta
  end

  version :large_plus do
    process manipulation_type => [600, 600]
    process :store_meta
  end


end
