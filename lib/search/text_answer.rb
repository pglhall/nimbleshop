module Search
  class TextAnswer < BaseAnswer

    private

    def contains
      query_column.matches("%#{@value}%")
    end

    def ends
      query_column.matches("%#{@value}")
    end

    def starts
      query_column.matches("#{@value}%")
    end

    def eq
      query_column.matches(@value)
    end

    def query_column
      arel_table[:value]
    end

    def valid_operators
      %w(eq contains starts ends)
    end
  end
end
