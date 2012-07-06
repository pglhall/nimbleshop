class Product < ActiveRecord::Base

  include Permalink::Builder

  alias_attribute :title, :name

  attr_accessor :pictures_order

  validates :status, inclusion: { in: %w(active hidden sold_out) }, presence: true

  has_many :pictures, order: 'pictures.position'

  has_many :custom_field_answers, dependent: :destroy

  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: proc { |r| r[:picture].blank? }

  accepts_nested_attributes_for :custom_field_answers, allow_destroy: true

  after_initialize :initialize_status

  scope :with_prictures, includes: 'pictures'

  scope :active,    where(status: 'active')
  scope :hidden,    where(status: 'hidden')
  scope :sold_out,  where(status: 'sold_out')


  validates_presence_of :name, :description, :price

  validates_numericality_of :price

  def picture
    pictures.first
  end

  # path is full path to the picture.
  #
  # Rails.root.join('db', 'original_pictures', filename )
  #
  # This method is used only in development and test to attach a picture.
  def attach_picture(filename, path)
    img = File.open(path) {|i| i.read}
    encoded_img = Base64.encode64 img
    io = FilelessIO.new(Base64.decode64(encoded_img))
    io.original_filename = filename
    p = Picture.new(product: self, picture: io)
    p.save
  end

  def find_or_build_answer_for_field(field)
    custom_field_answers.detect {|t| t.custom_field_id.to_s == field.id.to_s } ||
      custom_field_answers.build(custom_field_id: field.id)
  end

  def find_or_build_all_answers
    CustomField.all.each { |f| find_or_build_answer_for_field(f) }
  end


  def pictures_order=(value)
    return if value.empty?
    ordered_pictures = ActiveSupport::JSON.decode(value)
    current_pictures = pictures

    ordered_pictures.each{|position, picture_id|
      if picture_id.present?
        pic = current_pictures.find { |x| x.id == picture_id.to_i }
        pic.update_column(:position, position) if pic
      end
    }
  end

  def initialize_status
    self.status ||= 'active'
  end
end
