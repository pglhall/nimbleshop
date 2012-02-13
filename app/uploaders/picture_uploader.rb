# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    #"/uploads/picture/picture/0/" + [version_name, "no-image.png"].compact.join('_')
    "/images/no_image/" + [version_name, "no-image.png"].compact.join('_')
  end

  version :pico do
    process :resize_to_limit => [16, 16]
  end

  version :icon do
    process :resize_to_limit => [32, 32]
  end

  version :thumb do
    process :resize_to_limit => [50, 50]
  end

  version :small do
    process :resize_to_limit => [100, 100]
  end

  version :compact do
    process :resize_to_limit => [160, 160]
  end

  version :medium do
    process :resize_to_limit => [240, 240]
  end

  version :large do
    process :resize_to_limit => [480, 480]
  end

  version :grande do
    process :resize_to_limit => [600, 600]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
