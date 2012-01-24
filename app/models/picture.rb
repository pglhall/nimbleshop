class Picture < ActiveRecord::Base
  belongs_to :product

  mount_uploader :picture, PictureUploader

  before_save :set_picture_attributes

  private

  def set_picture_attributes
    if picture.present? && picture_changed?
      self.content_type = picture.file.content_type
      self.file_size    = picture.file.size
    end
  end

end
