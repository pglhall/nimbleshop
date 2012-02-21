class Picture < ActiveRecord::Base
  belongs_to :product

  mount_uploader :picture, PictureUploader

  %w(tiny tiny_plus small small_plus medium medium_plus large large_plus).each do |version|
    define_method :"#{version}_height" do
      self.picture.send(version).height
    end

    define_method :"#{version}_width" do
      self.picture.send(version).width
    end
  end

end
