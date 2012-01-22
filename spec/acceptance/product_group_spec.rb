require 'spec_helper'

describe "product group integration" do
  it "should show Nimble shop" do
    visit '/'
    page.has_content?('Nimble').must_equal true
  end
end
