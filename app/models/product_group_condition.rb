class ProductGroupCondition < ActiveRecord::Base

  belongs_to :product_group

  attr_reader :query_column, :query_strategy

  attr_accessor :index

  delegate :where, :to => :query_strategy

  validates_presence_of :name, :operator, :value

  validate :validate_operator

  after_initialize :set_strategy


  def validate_operator
    unless @query_strategy.valid_operator?(operator)
      self.errors.add(:operator, :invalid)
    end
  end

  def name=(val)
    val = val.try(:to_s)
    if super(val)
      set_strategy
    end
  end

  def set_strategy
    set_join_module
    @query_strategy = self.class.const_get("#{field_type.classify}Field").new(self)
  end

  def summary
    I18n.t(self.operator.to_sym, field: localized_name, value: self.value)
  end

  private

  def set_join_module
    extend(custom_field? ? CustomFieldStrategy : CoreFieldStrategy)
  end

  def arel_field
    target_table.send(:[], query_column)
  end

  module CustomFieldStrategy
    def join(proxy)
      product_arel_table = Product.arel_table
      proxy.join(target_table).on(target_table[:product_id].eq(product_arel_table[:id]))
    end

    def target_table
      unless @_target
        @_target =CustomFieldAnswer.arel_table.alias("answers#{index}")
      end
      @_target
    end

    def custom_field
      @_field ||= CustomField.find(self.name)
    end

    def query_column
      field_type = custom_field.field_type
      if field_type == 'text'
        :value
      else
        "#{field_type}_value".to_sym
      end
    end

    def field_type
      custom_field.field_type
    end

    def localized_name
      custom_field.name
    end
  end

  module CoreFieldStrategy
    def join(proxy)
      proxy
    end

    def target_table
      unless @_target
        @_target = Product.arel_table
      end
      @_target
    end

    def query_column
      self.name.try(:to_sym)
    end

    def field_type
      if query_column == :price
        'number'
      else
        'text'
      end
    end

    def localized_name
      self.name
    end
  end

  class BaseField
    attr_accessor :condition
    delegate :arel_field, :to => :condition

    def initialize(condition)
      self.condition = condition
    end

    def valid_operator?(operator)
      valid_operators.include?(operator.to_s)
    end

    def where(proxy = nil)
      clause = send(condition.operator, condition.value)
      proxy ? proxy.and(clause) : clause
    end
  end

  class TextField < BaseField
    delegate :matches, :to => :arel_field

    def contains(val)
      matches("%#{val}%")
    end

    def ends(val)
      matches("%#{val}")
    end

    def starts(val)
      matches("#{val}%")
    end

    def eq(val)
      matches(val)
    end

    def valid_operators
      %w(eq contains starts ends)
    end
  end

  class NumberField < BaseField
    delegate :eq, :lt, :gt, :lteq, :gteq, :to => :arel_field

    def valid_operators
      %w(eq lt gt lteq gteq)
    end
  end

  class DateField < NumberField
  end

  def custom_field?
    self.name =~ /\d+/
  end

  def custom_field
    if custom_field?
    end
  end
end
