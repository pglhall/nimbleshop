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

  sizes = { tiny:        [16, 16],
            tiny_plus:   [32, 32],
            small:       [50, 50],
            small_plus:  [100, 100],
            medium:      [160, 160],
            medium_plus: [240, 240],
            large:       [480, 480],
            large_plus:  [600, 600]
          }

  version :tiny do
    process manipulation_type => sizes.fetch(:tiny)
    process :store_meta
  end

  version :tiny_plus do
    process manipulation_type => sizes.fetch(:tiny_plus)
    process :store_meta
  end

  version :small do
    process manipulation_type => sizes.fetch(:small)
    process :store_meta
  end

  version :small_plus do
    process manipulation_type => sizes.fetch(:small_plus)
    process :store_meta
  end

  version :medium do
    process manipulation_type => sizes.fetch(:medium)
    process :store_meta
  end

  version :medium_plus do
    process manipulation_type => sizes.fetch(:medium_plus)
    process :store_meta
  end

  version :large do
    process manipulation_type => sizes.fetch(:large)
    process :store_meta
  end

  version :large_plus do
    process manipulation_type => sizes.fetch(:large_plus)
    process :store_meta
  end


end
