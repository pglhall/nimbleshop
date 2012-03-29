require 'spec_helper'

describe "homepage_spec integration" do

  before do
    visit root_path
  end

  it "should render fine" do
    page.has_content?('powered by').must_equal true
  end

  if "should render fine with link_group deleted" do
    LinkGroup.delete_all
    page.has_content?('powered by').must_equal true
  end

end
