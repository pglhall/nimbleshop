class PaymentTransaction < ActiveRecord::Base
  belongs_to  :order
  serialize   :params,          Hash
  serialize   :additional_info, Hash

  def to_partial_path
    "admin/orders/payment_transactions/#{order.payment_method.class.partialize}"
  end
end
