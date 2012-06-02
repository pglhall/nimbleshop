class PaymentMethod < ActiveRecord::Base

  store :metadata

  include Permalink::Builder

  scope :enabled, where(enabled: true)

  # By default payment_method does not require that application must use SSL. 
  # Individual payment method should override this method.
  def use_ssl?
    false
  end

  def demodulized_underscore
    self.class.name.demodulize.underscore
  end

  def enable!
    update_attribute(:enabled, true)
  end

  def disable!
    update_attribute(:enabled, false)
  end

  def self.partialize
    name.gsub("PaymentMethod::","").underscore
  end
end
