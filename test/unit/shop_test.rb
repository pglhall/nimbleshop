require 'test_helper'

class ShopTest < ActiveSupport::TestCase

  test 'twitter handle' do
    shop = build :shop, twitter_handle: '@nimbleshop'
    shop.valid?
    assert_equal 'nimbleshop', shop.twitter_handle
  end

end
