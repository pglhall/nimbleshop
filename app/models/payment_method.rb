class PaymentMethod < ActiveRecord::Base

  include BuildPermalink

  before_save :set_data

  serialize :data

  scope :enabled, where(enabled: true)

  def set_mode
    # FIXME before going live
    #ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test
    ActiveMerchant::Billing::Base.mode = :test
  end

  after_initialize :set_data_instance_variables

  def self.load_default!
    if count > 0
      raise "Only load into empty db"
    end

    file  = File.join(Rails.root, 'config', 'payment.yml')
    config = YAML::load(ERB.new(IO.read(file)).result)[Rails.env]

    config.each_pair do | payment_method_name, preferences |
      attributes = { 
        name: preferences.delete("name"), 
        description: preferences.delete("description") 
      }
    
      payment_klass = const_get(payment_method_name.classify)

      instance = payment_klass.create!(attributes)

      preferences.each_pair do | preference, value |
        instance.write_preference(preference.to_sym, value)
      end
      instance.save
    end
  end

  private

  def set_data
    self.data = { }
  end

  def set_data_instance_variables
    return if self.data.blank?
    self.data.each do |key, value|
      self.instance_variable_set("@#{key.to_s}", value)
    end
  end

end
