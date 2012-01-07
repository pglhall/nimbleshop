module Search
  class DateField < NumberField
    def valid_value_data_type?
      value.acts_like?(:date)
    end
  end
end
