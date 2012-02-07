class RegionalCodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    # TODO there is an API from carmen rather than looping through all results
    unless record.country.subregions.any? { |t| t.code == value }
      record.errors[attribute] << 'must be valid region code'
    end
  end
end
