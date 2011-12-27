class CustomFieldAnswer
  module Condition
    extend ActiveSupport::Concern

    class OperatorNotSupported < StandardError #:nordoc
    end

    module ClassMethods

      def to_arel_conditions(conditions)
        [].tap do | result |
          Array.wrap(conditions).each_with_index do | condition, index |
            field  = condition.keys.first
            result << to_condition_klass(field).new(condition[field].merge(i: index)) 
          end
        end
      end

      private

      def to_condition_klass(field)
        const_get("#{CustomField.find(field.gsub(/q/,'')).field_type.camelize}Condition")
      end
    end

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
          raise OperatorNotSupported.new("unknown operator #{@operation}")
        end
      end

      def arel_table
        @arel_table ||= CustomFieldAnswer.arel_table.alias("answers#{@index}")
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
