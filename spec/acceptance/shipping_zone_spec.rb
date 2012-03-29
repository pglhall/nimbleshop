require 'spec_helper'

describe "shipping_zones_accepttance_spec integration" do
  it "should create new shipping zone" do
    visit "/admin"
    click_link "Shipping zones"
    click_link "Add new shipping zone"
  end
end
