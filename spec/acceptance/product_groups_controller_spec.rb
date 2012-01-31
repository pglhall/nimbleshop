require 'spec_helper'

describe "product group integration" do

  it "should show Nimble shop" do
    visit root_path
    page.has_content?('Shop by category').must_equal true
  end
end
