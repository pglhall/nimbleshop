class PaymentMethod < ActiveRecord::Base
  before_create :set_permalink
  before_save :set_data

  serialize :data

  def set_mode
    #ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test
    ActiveMerchant::Billing::Base.mode = :test
  end

  after_initialize :set_data_instance_variables

  private

  def set_permalink
    permalink = self.name.parameterize
    counter = 2

    while self.class.exists?(permalink: permalink) do
      permalink = "#{permalink}-#{counter}"
      counter = counter + 1
    end

    self.permalink ||= permalink
  end

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
