require 'spec_helper'

describe "product_groups_acceptance_spec integration" do

  def create_product_group(name, attrs)
    visit new_admin_product_group_path
    fill_in 'Name', with: name
    select  attrs[:field], from: 'product_group_product_group_conditions_attributes_0_name'
    select attrs[:operator], from: 'product_group_product_group_conditions_attributes_0_operator'
    fill_in 'product_group_product_group_conditions_attributes_0_value', with: attrs[:value]
    click_button 'Submit'
  end

  before do
    create(:product, :name => "Nike Shoes1",   status: 'active')
    create(:product, :name => "Nike Shoes2",   status: 'active')
    create(:product, :name => "Rebook Shoes", status: 'hidden')
    create(:product, :name => "Basics Shoes", status: 'sold_out')
  end

  describe "creating product group" do
    it {
      create_product_group('Nike', field:'Name', operator: 'Contains', value: 'Nike')
      page.must_have_content('Successfuly updated')
    }
  end

  describe "viewing product group" do
    before do
      create_product_group('Nike', field:'Name', operator: 'Contains', value: 'Nike')
    end
    describe "when product is active" do
      it {
        visit product_group_path(ProductGroup.find_by_name('Nike'))

        page.must_have_content('Nike Shoes1')
        page.must_have_content('Nike Shoes2')
      }
    end

    describe "when product is not active" do
      it {
        Product.find_by_name('Nike Shoes1').update_attributes(status: 'sold_out')
        visit product_group_path(ProductGroup.find_by_name('Nike'))

        page.wont_have_content('Nike Shoes1')
        page.must_have_content('Nike Shoes2')
      }
    end
  end
end
