class Picture < ActiveRecord::Base
  belongs_to :product

  mount_uploader :picture, PictureUploader
end
