class CountryCodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless record.country_code
      record.errors[attribute] << 'must be valid country code' 
    end
  end
end
