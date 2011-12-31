module Search
  class BaseAnswer
    def initialize(params = {})
      @name      = to_name(params[:name])
      @value     = params[:v]
      @index     = params[:i]
      @operation = params[:op]

      validate_operator!
    end

    def arel_join(table, prv_join = nil)
      prv_join ||= table
      prv_join.join(arel_table).on(arel_table[:product_id].eq(table[:id]))
    end

    def to_condition
      send(@operation)
    end

    def summary
     "#{@name} is #{I18n.t(@operation.to_sym)} #{@value}"
    end

    private

    def to_name(field)
      CustomField.find(field.gsub(/q/,'')).name
    end

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
