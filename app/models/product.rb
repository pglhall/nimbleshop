class Product < ActiveRecord::Base

  alias_attribute :title, :name

  include BuildPermalink

  has_many :pictures
  accepts_nested_attributes_for :pictures#, allow_destroy: true

  has_many :custom_field_answers do
    def for(custom_field_name)
      # TODO this one is causing one extra query. Look into removing it
      custom_field = CustomField.find_by_name(custom_field_name)
      where(['custom_field_answers.custom_field_id = ?', custom_field.id]).limit(1).try(:first)
    end
  end

  before_create :set_permalink

  validates_presence_of :name, :description, :price
  validates_numericality_of :price

  def picture
    pictures.first
  end

  def self.with_pictures
    includes(:pictures)
  end

  # TODO this method should not exist. All such custom fields should be generated dynamically
  def category
    custom_field_value_for('category')
  end

  def custom_field_value_for(custom_field_name)
    self.custom_field_answers.for(custom_field_name).value
  end

  def self.search(params = {})
    conditions = CustomFieldAnswer.to_arel_conditions(params)

    relation = conditions.inject(nil) do | t, condition| 
     condition.arel_join(arel_table, t)
    end

    wh = conditions.inject(nil) do | t, condition |
      t.nil? ? condition.to_condition : t.and(condition.to_condition)
    end

    Product.find_by_sql(relation.where(wh).project(Arel.sql("products.*")).to_sql)
  end
end
