class Picture < ActiveRecord::Base

  belongs_to :product

  mount_uploader :picture, PictureUploader

  before_save :update_picture_attributes

  %w(tiny tiny_plus small small_plus medium medium_plus large large_plus carousel).each do |version|
    define_method :"#{version}_height" do
      self.picture.send(version).height
    end

    define_method :"#{version}_width" do
      self.picture.send(version).width
    end
  end

  private

  def update_picture_attributes
    if picture.present?
      self.content_type = picture.file.content_type
      self.file_size = picture.file.size
    end
  end

end
