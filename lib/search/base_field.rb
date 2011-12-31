module Search
  module BaseField
    def arel_join(table, prv_join = nil)
      prv_join || table
    end

    private

    def to_name(field)
      field
    end

    def arel_table
      Product.arel_table
    end

    def query_column
      arel_table[@name.to_sym]
    end
  end
end
