require 'spec_helper'

describe "product group integration" do

  before do
    Shop.destroy_all
    create(:shop, name: 'Nimble')
  end

  it "should show Nimble shop" do
    visit '/'
    page.has_content?('Nimble').must_equal true
  end
end
