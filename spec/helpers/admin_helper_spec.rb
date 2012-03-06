require 'spec_helper'


describe AdminHelper do
  def helper
    Class.new(ActionView::Base) do
      include AdminHelper
    end.new
  end

  describe "#active?" do

    context "admin_products_path" do
      it {
        helper.active?('admin_products_path', 'admin/products').must_equal true
        helper.active?('admin_products_path', 'admin/orders').must_equal false
      }
    end


    context "admin_custom_fields_path" do
      it {
        helper.active?('admin_custom_fields_path', 'admin/custom_fields').must_equal true
        helper.active?('admin_custom_fields_path', 'admin/orders').must_equal false
      }
    end

    context "admin_product_groups_path" do
      it {
        helper.active?('admin_product_groups_path', 'admin/product_groups').must_equal true
        helper.active?('admin_product_groups_path', 'admin/orders').must_equal false
      }
    end

    context "admin_link_groups_path" do
      it {
        helper.active?('admin_link_groups_path', 'admin/link_groups').must_equal true
        helper.active?('admin_link_groups_path', 'admin/orders').must_equal false
      }
    end

    context "admin_shipping_zones_path" do
      it {
        helper.active?('admin_shipping_zones_path', 'admin/shipping_zones').must_equal true
        helper.active?('admin_shipping_zones_path', 'admin/shipping_methods').must_equal true
        helper.active?('admin_shipping_zones_path', 'admin/orders').must_equal false
      }
    end

    context "admin_payment_methods_path" do
      it {
        helper.active?('admin_payment_methods_path', 'admin/payment_methods').must_equal true
        helper.active?('admin_payment_methods_path', 'admin/orders').must_equal false
      }
    end

    context "edit_admin_shop_path" do
      it {
        helper.active?('edit_admin_shop_path', 'admin/shops').must_equal true
        helper.active?('edit_admin_shop_path', 'admin/orders').must_equal false
      }
    end

    context "edit_admin_orders_path" do
      it {
        helper.active?('edit_admin_orders_path', 'admin/orders').must_equal true
        helper.active?('edit_admin_orders_path', 'admin/products').must_equal false
      }
    end
  end
end
