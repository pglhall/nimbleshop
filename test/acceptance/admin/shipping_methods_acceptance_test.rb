require "test_helper"

class ShippingMethodAcceptanceTest < ActionDispatch::IntegrationTest

  def create_shipping_zone(code)
    create(:country_shipping_zone, country_code: code)
  end

  test "add new shipping method to country" do
    bef = ShippingZone.count
    shipping_zone = create_shipping_zone("US")
    visit new_admin_shipping_zone_shipping_method_path(shipping_zone)

    fill_in "shipping_method_name", with: "Ground Shipping"
    fill_in "shipping_method_lower_price_limit", with: "10"
    fill_in "shipping_method_upper_price_limit", with: "30"
    fill_in "shipping_method_base_price", with: "10"
    click_button('Submit')

    assert page.has_content?('Successfully created')
    assert_equal 58, ShippingZone.count - bef
  end

  test "edit shipping method to country" do
    shipping_zone = create_shipping_zone("US")
    shipping_method = create(:country_shipping_method, shipping_zone: shipping_zone)
    visit edit_admin_shipping_zone_shipping_method_path(shipping_method.shipping_zone, shipping_method)
    fill_in "shipping_method_upper_price_limit", with: "40"
    click_button('Submit')

    assert page.has_content?('Successfully updated')
  end

  test "disbale state shipping zone" do
    Capybara.current_driver = :selenium

    shipping_zone = create_shipping_zone("US")
    state_zone = shipping_zone.regional_shipping_zones[0]
    shipping_method = create(:country_shipping_method, :shipping_zone => shipping_zone)
    visit edit_admin_shipping_zone_shipping_method_path(shipping_zone, shipping_method)

    find("a[@rel='disable-#{state_zone.id} nofollow']").click

    assert page.has_content?('Enable')

    Capybara.current_driver = :rack_test
  end

  test "enable state shipping zone" do
    Capybara.current_driver = :selenium

    shipping_zone = create_shipping_zone("US")
    state_zone = shipping_zone.regional_shipping_zones[0]
    shipping_method = create(:country_shipping_method, :shipping_zone => shipping_zone)

    visit edit_admin_shipping_zone_shipping_method_path(shipping_zone,shipping_method)
    find("a[@rel='disable-#{state_zone.id} nofollow']").click
    find("a[@rel='enable-#{state_zone.id} nofollow']").click

    Capybara.current_driver = :rack_test
  end

end
