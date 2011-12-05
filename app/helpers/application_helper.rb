module ApplicationHelper

  def items_count_in_cart
    current_order.blank? ? 0 : current_order.item_count
  end

  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}|
  end

end
