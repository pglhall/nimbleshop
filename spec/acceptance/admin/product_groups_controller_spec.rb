require 'spec_helper'

describe "Product Groups integration" do

  before do
    create(:price_group_condition)
    create(:date_group_condition)
  end

  describe "index" do
    it "should be at index page" do
      visit admin_product_groups_path
      page.has_content?("Product groups").must_equal true
      click_button '+ Add new product group'
p page.body
      fill_in 'Name', with: 'price < 43'
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_0_name']/option['price']").text, :from => 'product_group_product_group_conditions_attributes_0_name')
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_0_operator']/option['equal']").text, :from => 'product_group_product_group_conditions_attributes_0_operator')
      fill_in 'product_group_product_group_conditions_attributes_0_value', with: '43'
      click_link 'add'
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_1_name']/option['name']").text, :from => 'product_group_product_group_conditions_attributes_0_name')
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_1_operator']/option['contains']").text, :from => 'product_group_product_group_conditions_attributes_0_operator')
      fill_in 'product_group_product_group_conditions_attributes_1_value', with: 'candy'
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal true
      page.has_content?("name contains '43' and name contains 'candy'").must_equal true

    end
  end

end
