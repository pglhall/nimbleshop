class DateCondition < NumberCondition

  private

  def query_column
    arel_table[:datetime_value]
  end
end
