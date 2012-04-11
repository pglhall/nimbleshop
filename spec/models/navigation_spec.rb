require 'spec_helper'

#describe Navigation do
  #describe "validations" do
    #subject { create(:navigation) }
    #it {
      #must validate_presence_of(:product_group)
      #must validate_presence_of(:link_group)
    #}
  #end
#end

class NavigationTest < ActiveRecord::TestCase
  test "validate presence of product_group" do
    navigation = build :navigation, product_group: nil

    assert navigation.invalid?, "record : #{navigation.errors.full_messages.inspect}"
    assert_equal ["can't be blank"], navigation.errors[:product_group]
  end

  test "validate presence of link_group" do
    navigation = build :navigation, link_group: nil

    assert navigation.invalid?, "record : #{navigation.errors.full_messages.inspect}"
    assert_equal ["can't be blank"], navigation.errors[:link_group]
  end
end
