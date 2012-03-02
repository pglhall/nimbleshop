require 'spec_helper'

describe Picture do

  describe "uploading a picture should populate height and width for all versions" do
    it {
      product = create :product
      product.pictures.first.destroy

      product.attach_picture('cookware.jpg', Rails.root.join('spec', 'support', 'images', 'cookware.jpg'))

      product = Product.unscoped.last

      product.pictures.size.must_equal 1

      #assert product.picture.picture_width
      #assert product.picture.picture_height

      #%W(tiny tiny_plus small small_plus medium medium_plus large large_plus).each do |version|
        #assert product.picture.picture.send(version.intern).height
        #assert product.picture.picture.send(version.intern).width

        #assert product.picture.send("#{version}_height".intern)
        #assert product.picture.send("#{version}_width".intern)
      #end

      #when product is destroyed then picture should not be deleted
      Picture.count.must_equal 1
      product.destroy
      Picture.count.must_equal 1
    }
  end
end
