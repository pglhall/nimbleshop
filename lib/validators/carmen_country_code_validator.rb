class CarmenCountryCodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless Carmen::Country.coded(value)
      record.errors[attribute] << 'must be valid country code' 
    end
  end
end
