require 'test_helper'

class StaticPagesAcceptanceTest < ActionDispatch::IntegrationTest
  test "static pages" do
    visit root_path

    click_link 'About us'
    assert page.has_content?('is a free and open source e-commerce framework based on Ruby on Rails')

    click_link 'Contact us'
    assert page.has_content?('hello.nimbleshop@gmail.com')
  end
end
