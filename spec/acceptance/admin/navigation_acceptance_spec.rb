require 'spec_helper'

describe "navigation integration" do
  before do
    @product_group = create :product_group, name: "Nike Shoes"
    @link_group    = create :link_group,    name: "Branded Shoes"
  end

  describe "add new navigation to link group" do
    it do
      visit new_admin_link_group_navigation_path(@link_group)
      select "Nike Shoes", from: 'Product Group'
      click_button "Add"

      page.must_have_content('Successfully added')
    end
  end

  describe "delete navigation from link group" do
    before do
      @nav = @link_group.navigations.create(product_group: @product_group)
      Capybara.current_driver =  :selenium
    end

    it do
      visit admin_link_groups_path
      page.evaluate_script('window.confirm = function() { return true; }')
      find("a[href='#{admin_link_group_navigation_path(link_group_id: @link_group, id: @nav)}']").click
      page.must_have_content('Successfully deleted')
    end
  end
end
