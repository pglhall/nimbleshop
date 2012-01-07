module Search
  class NumberField < BaseField
    delegate :eq, :lt, :gt, :lteq, :gteq, :to => :arel_field

    def valid_value_data_type?
      value.try(:match, /\A[+-]?\d+?(\.\d+)?\Z/).present?
    end

    def valid_operators
      %w(eq lt gt lteq gteq)
    end
  end
end
