class PaymentMethod < ActiveRecord::Base

  include Permalink::Builder

  store :settings

  scope :enabled, where(enabled: true)

  def use_ssl
    settings[:use_ssl]
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

    payment_data.each_pair do | payment_method_name, value |
      attributes = {
        name: value.delete(:name),
        description: value.delete(:description)
      }

      payment_klass = const_get(payment_method_name.to_s.classify)

      instance = payment_klass.new(attributes)

      value.each_pair { | attr, value | instance.send("#{attr}=", value) }

      instance.save
    end
  end


  def self.partialize
    name.gsub("PaymentMethod::","").underscore
  end
end
