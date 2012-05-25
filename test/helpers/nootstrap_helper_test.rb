require 'test_helper'

class NootstrapHelperTest < ActiveRecord::TestCase

  def helper
    Class.new(ActionView::Base) do
      include NootstrapHelper
    end.new
  end

  test "display_address" do
    addr = create(:address, address1: "<script>alert('hi')</script>")
    output = helper.display_address(addr)
    refute output.include?('<script>')
  end

end
