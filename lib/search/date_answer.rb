module Search
  class DateAnswer < NumberAnswer

    private

    def query_column
      arel_table[:datetime_value]
    end
  end
end
