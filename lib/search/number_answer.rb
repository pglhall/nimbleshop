module Search
  class NumberAnswer < BaseAnswer

    private

    def eq
      query_column.eq(@value)
    end

    def gt
      query_column.gt(@value)
    end

    def lt
      query_column.lt(@value)
    end

    def lteq
      query_column.lteq(@value)
    end

    def gteq
      query_column.gteq(@value)
    end

    def query_column
      arel_table[:number_value]
    end

    def valid_operators
      %w(eq lt gt lteq gteq)
    end
  end
end
