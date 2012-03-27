require 'test_helper'

class HomepageIntegrationTest < ActionDispatch::IntegrationTest

  test "home page with link groups" do
    visit root_path

    assert page.has_content?('powered by')
    assert page.has_content?('Shop by category')
  end

  test "home page without link groups" do
    LinkGroup.delete_all

    visit root_path

    assert page.has_content?('powered by')
    assert !page.has_content?('Shop by category')
  end
end
