require 'test_helper'

class AdminHelperTest < ActiveRecord::TestCase

  def helper
    Class.new(ActionView::Base) do
      include AdminHelper
    end.new
  end

  test "admin_products_path" do
    assert helper.admin_topbar_active?('admin_products_path', 'admin/products')
    refute helper.admin_topbar_active?('admin_products_path', 'admin/orders')

    assert helper.admin_topbar_active?('admin_custom_fields_path', 'admin/custom_fields')
    refute helper.admin_topbar_active?('admin_custom_fields_path', 'admin/orders')

    assert helper.admin_topbar_active?('admin_product_groups_path', 'admin/product_groups')
    refute helper.admin_topbar_active?('admin_product_groups_path', 'admin/orders')

    assert helper.admin_topbar_active?('admin_link_groups_path', 'admin/link_groups')
    refute helper.admin_topbar_active?('admin_link_groups_path', 'admin/orders')

    assert helper.admin_topbar_active?('admin_shipping_zones_path', 'admin/shipping_zones')
    assert helper.admin_topbar_active?('admin_shipping_zones_path', 'admin/shipping_methods')
    refute helper.admin_topbar_active?('admin_shipping_zones_path', 'admin/orders')

    assert helper.admin_topbar_active?('admin_payment_methods_path', 'admin/payment_methods')
    refute helper.admin_topbar_active?('admin_payment_methods_path', 'admin/orders')

    assert helper.admin_topbar_active?('edit_admin_shop_path', 'admin/shops')
    refute helper.admin_topbar_active?('edit_admin_shop_path', 'admin/orders')

    assert helper.admin_topbar_active?('admin_orders_path', 'admin/orders')
  end

end
