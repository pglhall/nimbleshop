class RegionalCodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless record.country_code.subregions.any? { |t| t.code == value }
      record.errors[attribute] << 'must be valid region code' 
    end
  end
end
