require 'active_merchant/billing/integrations/action_view_helper'

module NimbleshopPaypalwp
  module ApplicationHelper
    include ActiveMerchant::Billing::Integrations::ActionViewHelper
  end
end
