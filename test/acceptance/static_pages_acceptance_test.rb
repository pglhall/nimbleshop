require 'test_helper'

class StaticPagesIntegrationTest < ActionDispatch::IntegrationTest
  test "static pages" do
    visit root_path

    click_link 'About us'
    assert page.has_content?('is a would be open source Ruby on Rails e-commerce framework')

    click_link 'Contact us'
    assert page.has_content?('hello.nimbleshop@gmail.com')
  end
end


