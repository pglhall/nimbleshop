require 'spec_helper'

describe "link_groups_acceptance_spec integration" do
  before do
    @product_group = create :product_group, name: "Nike Shoes"
    @link_group    = create :link_group,    name: "Branded Shoes"
  end

  describe "add a new link group" do
    it {
      visit admin_path
      click_link 'Link groups'
      click_link 'add_new_link_group'
      fill_in 'link_group_name', with: 'Popular products'
      click_button 'Submit'
      assert page.has_content?('Successfuly added')
      assert page.has_content?('Popular products')
    }
  end

  describe "add new link" do
    it do
      visit admin_path
      click_link 'Link groups'
      refute page.has_content?('Nike Shoes')
      click_link 'Add new link'
      select "Nike Shoes", from: 'Product Group'
      click_button "Add"
      assert page.has_content?('Nike Shoes')
    end
  end

  describe "delete link group" do
    before do
      @nav = @link_group.navigations.create(product_group: @product_group)
      Capybara.current_driver =  :selenium
    end

    it do
      visit admin_link_groups_path
      page.evaluate_script('window.confirm = function() { return true; }')
      find("a[href='#{admin_link_group_navigation_path(link_group_id: @link_group, id: @nav)}']").click
      assert page.has_content?('Successfully deleted')
    end
  end
end
