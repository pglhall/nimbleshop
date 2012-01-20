require 'spec_helper'

describe "shipping zone" do

  before do
    Shop.destroy_all
    create(:shop, name: 'Nimble')
    visit_admin_page
  end

  it "should create new shipping zone" do
    click_link "Shipping zones"
    click_link "Add new shipping zone"
    click_link "Submit"
  end
end
