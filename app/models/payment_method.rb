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

  def self.load_seed_data!
    if count > 0
      #raise "Only load into empty db"
    end

    payment_data = ConfigLoader.new('payment.yml').load

    payment_data.each_pair do | permalink, value |
      attributes = {
        name: value.delete(:name),
        description: value.delete(:description)
      }

      k = permalink.capitalize
      payment_klass = "::Nimbleshop#{k}::#{k}".constantize

      instance = payment_klass.new(attributes)

      value.each_pair { | attr, value | instance.send("#{attr}=", value) }

      instance.save
    end
  end

  def self.partialize
    name.gsub("PaymentMethod::","").underscore
  end
end
