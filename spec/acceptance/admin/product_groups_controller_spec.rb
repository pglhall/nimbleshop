require 'spec_helper'

describe "Product Groups integration" do

  before do
    create(:price_group_condition)
    create(:date_group_condition)
    Capybara.current_driver = :webkit
  end

  describe "good path" do
    it "should allow to list and create a product group" do
      visit admin_product_groups_path
      page.has_content?("Product groups").must_equal true
      click_link 'add_new_product_group'

      fill_in 'Name', with: 'sweet candies'
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_0_name']/option[@value='name']").text, :from => 'product_group_product_group_conditions_attributes_0_name')
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_0_operator']/option[@value='contains']").text, :from => 'product_group_product_group_conditions_attributes_0_operator')
      fill_in 'product_group_product_group_conditions_attributes_0_value', with: 'candy'
      click_link 'Add'

      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_1_name']/option[@value='name']").text, :from => 'product_group_product_group_conditions_attributes_1_name')
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_1_operator']/option[@value='starts']").text, :from => 'product_group_product_group_conditions_attributes_1_operator')
      fill_in 'product_group_product_group_conditions_attributes_1_value', with: 'sweet'
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal true
      page.has_content?("name contains 'candy' and name starts with 'sweet'").must_equal true

      click_link 'Edit'

      fill_in 'Name', with: 'awesome candies'
      fill_in 'product_group_product_group_conditions_attributes_0_value', with: 'awesome'
      select(find(:xpath, "//*[@id='product_group_product_group_conditions_attributes_0_operator']/option[@value='starts']").text, :from => 'product_group_product_group_conditions_attributes_0_operator')
      click_link 'Remove'
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal true
      page.has_content?("name starts with 'awesome'").must_equal true

#      https://github.com/thoughtbot/capybara-webkit/issues/109
      handle_js_confirm do
        click_link 'Delete'
      end
      page.has_content?("name starts with 'awesome'").must_equal false

    end
  end

  describe "bad path" do
    it "should not allow to create wrong product group" do
      visit admin_product_groups_path
      click_link 'add_new_product_group'
      fill_in 'Name', with: ''
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal false
      page.has_content?("Product group conditions value is invalid").must_equal true
      page.has_content?("Product group conditions value can't be blank").must_equal true
      page.has_content?("Name can't be blank").must_equal true
    end
  end

  private

  def handle_js_confirm(accept=true)
    page.execute_script "window.original_confirm_function = window.confirm"
    page.execute_script "window.confirmMsg = null"
    page.execute_script "window.confirm = function(msg) { window.confirmMsg = msg; return #{!!accept}; }"
    yield
  ensure
    page.execute_script "window.confirm = window.original_confirm_function"
  end

end
