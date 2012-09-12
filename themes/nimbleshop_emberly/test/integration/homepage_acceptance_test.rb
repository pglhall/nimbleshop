require 'test_helper'

class HomepageAcceptanceTest < ActionDispatch::IntegrationTest

  test 'home page with link groups' do
    assert_equal 1, Shop.count
    visit root_path

    assert page.has_content?('powered by')
    assert page.has_content?('Shop by category')
  end

  test 'home page without link groups' do
    assert_equal 1, Shop.count
    LinkGroup.delete_all

    visit root_path

    assert page.has_content?('powered by')
    refute page.has_content?('Shop by category')
  end
end
