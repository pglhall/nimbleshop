require 'spec_helper'

describe "homepage_spec integration" do

  before do
    visit root_path
  end

  it "should render fine" do
    page.has_content?('powered by').must_equal true
    page.must_have_content('Shop by category')
  end

  it "should render fine with link_group deleted" do
    LinkGroup.delete_all
    visit root_path
    page.has_content?('powered by').must_equal true
    page.must_have_content('Shop by category')
  end

end
