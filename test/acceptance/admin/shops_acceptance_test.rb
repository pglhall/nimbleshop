require 'test_helper'

class ShopsAcceptanceTest < ActionDispatch::IntegrationTest

  setup do
    create(:shop)
  end

  test "edit shop - good path" do
    visit admin_path
    click_link 'Shop configuration'
    assert page.has_content?('Shop configuration')
    fill_in 'Name', with: 'Jack Daniels'
    fill_in 'Theme', with: 'my-awesome-theme'
    fill_in 'Twitter handle', with: '@nimbleshop2'
    fill_in 'Facebook url', with: 'http://www.facebook.com/pages/NimbleSHOP/119319381517845'
    fill_in 'Contact email', with: 'shop@nimbleshop.com'
    fill_in 'Intercept email', with: 'shop@nimbleshop.com'
    fill_in 'From email', with: 'shop@nimbleshop.com'
    choose 'Authorize and capture the credit card for the total amount of the order .'
    select(find(:xpath, "//*[@id='shop_time_zone']/option[2]").text, :from => 'shop_time_zone')
    click_button 'Submit'

    assert page.has_content?('Shop was successfully updated')
  end

  test "edit shop - wrong path" do
    visit admin_path
    click_link 'Shop configuration'
    fill_in 'Name', with: ''
    fill_in 'Theme', with: ''
    fill_in 'Twitter handle', with: ''
    fill_in 'Facebook url', with: ''
    fill_in 'Contact email', with: ''
    fill_in 'Intercept email', with: ''
    fill_in 'From email', with: ''
    click_button 'Submit'

    assert page.has_content?('From email is invalid')
    assert page.has_content?('Intercept email is invalid')
    assert page.has_content?("Name can't be blank")
    assert page.has_content?("Theme can't be blank")

    fill_in 'Contact email', with: 'te@'
    fill_in 'Facebook url', with: 'wrong url'
    click_button 'Submit'

    assert page.has_content?('Facebook url is invalid')
    assert page.has_content?('Contact email is invalid')
  end
end
