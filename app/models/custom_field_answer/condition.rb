class CustomFieldAnswer
  module Condition
    extend ActiveSupport::Concern

    class OperatorNotSupported < StandardError #:nordoc
    end

    module ClassMethods

      def to_arel_conditions(params = {})
        params.map do | (field, condition) |
          if Array === condition
            condition.map { |cond| to_condition_klass(field).new(cond).to_condition }
          else
            to_condition_klass(field).new(condition).to_condition
          end
        end.flatten
      end

      private

      def to_condition_klass(field)
        const_get("#{CustomField.find(field.gsub(/q/,'')).field_type.camelize}Condition")
      end
    end

    class BaseCondition
      def initialize(params = {})
        @operation, @value = params.values_at(:op, :v)

        validate_operator!
      end

      def to_condition
        send(@operation)
      end

      private

      def validate_operator!
        unless valid_operators.include?(@operation)
          raise OperatorNotSupported.new("unknown operator #{@operation}")
        end
      end

      def arel_table
        CustomFieldAnswer.arel_table
      end
    end

    class NumberCondition < BaseCondition
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

    class DateCondition < NumberCondition

      private

      def query_column
        arel_table[:datetime_value]
      end
    end

    class TextCondition < BaseCondition

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
end
