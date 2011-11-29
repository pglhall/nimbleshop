class Product < ActiveRecord::Base

  alias_attribute :title, :name

  include Product::Scopes

  validates_presence_of :name, :description, :price

  validates_numericality_of :price

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

  liquid_methods :name, :url, :price, :picture_file_name, :id, :description, :permalink, :category

  def picture
    pictures.first
  end

  def self.with_pictures
    includes(:pictures)
  end

  def category
    custom_field_value_for('category')
  end

  def custom_field_value_for(custom_field_name)
    self.custom_field_answers.for(custom_field_name).value
  end

  def url
    "/products/#{self.id}"
  end

  def self.search(params = {})
    conditions = CustomFieldAnswer.to_arel_conditions(params)
    relation = self.scoped
    conditions.each do |condition|
      relation = relation.merge(where(condition))
    end
    relation = relation.joins(:custom_field_answers)
    relation.to_a
  end

  private

  # TODO move this to a separate gem
  def set_permalink
    permalink = self.name.parameterize
    counter = 2

    while self.class.exists?(permalink: permalink) do
      permalink = "#{permalink}-#{counter}"
      counter = counter + 1
    end

    self.permalink ||= permalink
  end
end

