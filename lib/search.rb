require 'search/core_field_strategy'
require 'search/custom_field_strategy'
require 'search/base_field'
require 'search/text_field'
require 'search/number_field'
require 'search/date_field'

module Search  
  extend ActiveSupport::Concern

  included do
    attr_reader :query_column, :query_strategy

    attr_accessor :index

    delegate  :where, 
      :valid_value_data_type?, 
      :valid_operator?, 
      :to => :query_strategy

    validate  :validate_value_data_type
    validate  :validate_operator

    after_initialize  :prepare_instance
  end

  def name=(val)
    val = val.try(:to_s)
    if super(val)
      prepare_instance
    end
  end

  def summary
    I18n.t(self.operator.to_sym, {
      field: localized_name, value: self.value
    })
  end

  private

  def validate_operator
    unless valid_operator?(operator)
      self.errors.add(:operator, :invalid)
    end
  end

  def validate_value_data_type
    unless valid_value_data_type?
      self.errors.add(:value, :invalid)
    end
  end

  def set_join_module
    extend(custom_field? ? CustomFieldStrategy : CoreFieldStrategy)
  end

  def prepare_instance
    set_join_module
    set_where_module
  end

  def set_where_module
    klass = Search.const_get("#{field_type.classify}Field")
    @query_strategy = klass.new(self)
  end

  def arel_field
    target_table.send(:[], query_column)
  end

  def custom_field?
    name.try(:match, /\A[+-]?\d+?\Z/).present?
  end
end
