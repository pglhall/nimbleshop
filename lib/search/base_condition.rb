module Search
  class BaseCondition
    def initialize(params = {})
      @operation, @value, @index = params.values_at(:op, :v, :i)

      validate_operator!
    end

    def arel_join(table, prv_join = nil)
      prv_join ||= table
      prv_join.join(arel_table).on(arel_table[:product_id].eq(table[:id]))
    end

    def to_condition
      send(@operation)
    end

    private

    def validate_operator!
      unless valid_operators.include?(@operation)
        raise Search::OperatorNotSupported.new("unknown operator #{@operation}")
      end
    end

    def arel_table
      @arel_table ||= CustomFieldAnswer.arel_table.alias("answers#{@index}")
    end
  end
end
