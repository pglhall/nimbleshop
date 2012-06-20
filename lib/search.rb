require 'search/core_field_strategy'
require 'search/custom_field_strategy'
require 'search/base_field'
require 'search/text_field'
require 'search/number_field'
require 'search/date_field'

module Search
  extend ActiveSupport::Concern

  included do

    # query_column is the value of name column in product_group_condition for core fields.
    # For custom fields this value will be overridden
    attr_reader :query_column

    # field_handler could be TextField, NumberField or any other field handler.
    attr_reader :field_handler

    # index is used by custom_field_strategy
    attr_accessor :index

    delegate  :where, :valid_value_data_type?, :valid_operator?, to: :field_handler

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

  # TODO megpha not sure if it is needed
  def summary
    I18n.t(self.operator.to_sym, { field: localized_name, value: self.value })
  end

  private

  def validate_operator
    self.errors.add(:operator, :invalid) unless valid_operator?(operator)
  end

  def validate_value_data_type
    self.errors.add(:value, :invalid) unless valid_value_data_type?
  end

  def prepare_instance
    set_strategy
    set_field_handler
  end

  def set_strategy
    extend(custom_field? ? CustomFieldStrategy : CoreFieldStrategy)
  end

  def set_field_handler
    klass = Search.const_get("#{field_type.classify}Field")
    @field_handler = klass.new(self)
  end

  def query_field
    target_table.send(:[], query_column)
  end

  def custom_field?
    # for a custom field the name column contains the primary key of the custom_fields table
    name.try(:match, /\A\d+?\Z/).present?
  end
end
