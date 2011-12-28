require 'search/base_condition'
require 'search/text_condition'
require 'search/number_condition'
require 'search/date_condition'

module Search
  extend ActiveSupport::Concern

  class OperatorNotSupported < StandardError #:nordoc
  end

  module ClassMethods

    def search(params = {})
      conditions = to_conditions(params)
      relation   = merge_joins(conditions).where(merge_where(conditions))
      relation   = relation.project(Arel.sql("products.*"))

      Product.find_by_sql(relation.to_sql)
    end

    def to_conditions(conditions)
      index = 0 

      Array.wrap(conditions).map do | condition |
        index = index + 1
      field, params  = condition.to_a.first

      klass = resolve_condition_klass(field)
      klass.new(params.merge(i: index)) 
      end
    end

    private

    def merge_joins(conditions)
      conditions.inject(nil) { | relation, condition| condition.arel_join(arel_table, relation) }
    end

    def merge_where(conditions)
      conditions.inject(nil) do | t, condition |
        t.nil? ? condition.to_condition : t.and(condition.to_condition)
      end
    end

    def resolve_condition_klass(field)
      field_type = case field
      when /(name|description)/
        'text'
      when /price/
        'number'
      else
        CustomField.find(field.gsub(/q/,'')).field_type
      end

      const_get("#{field_type.camelize}Condition")
    end
  end
end
