require 'spec_helper'

#describe Link do
  #describe "validations" do
    #subject { create(:link) }
    #it {
      #must validate_presence_of(:name)
      #must validate_presence_of(:url)
    #}
  #end
#end

class LinkTest < ActiveRecord::TestCase
  test "validate presence of name" do
    link = build :link, name: nil

    assert link.invalid?, "record : #{link.errors.full_messages.inspect}"
    assert_equal ["can't be blank"], link.errors[:name]
  end

  test "validate presence of url" do
    link = build :link, url: nil

    assert link.invalid?, "record : #{link.errors.full_messages.inspect}"
    assert_equal ["can't be blank"], link.errors[:url]
  end
end
